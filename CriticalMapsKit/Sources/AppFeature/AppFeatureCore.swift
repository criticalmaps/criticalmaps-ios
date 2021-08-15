import ApiClient
import ComposableArchitecture
import ComposableCoreLocation
import FileClient
import InfoBar
import Logger
import MapKit
import MapFeature
import NextRideFeature
import IDProvider
import SettingsFeature
import SharedModels
import UserDefaultsClient
import UIApplicationClient

public typealias InfoBannerPresenter = InfobarController

// MARK: State
public struct AppState: Equatable {
  public init(
    locationsAndChatMessages: Result<LocationAndChatMessages, LocationAndChatMessagesError>? = nil
  ) {
    self.locationsAndChatMessages = locationsAndChatMessages
  }
  
  public var locationsAndChatMessages: Result<LocationAndChatMessages, LocationAndChatMessagesError>?
  public var didResolveInitialLocation: Bool = false
  
  // Children states
  var mapFeatureState: MapFeatureState = MapFeatureState(
    riders: [],
    userTrackingMode: UserTrackingState(userTrackingMode: .follow)
  )
  var settingsState = SettingsState()
  var nextRideState = NextRideState()
  var requestTimer = RequestTimerState()
    
  // Navigation
  var route: AppRoute?
  var isChatViewPresented: Bool { route == .chat }
  var isRulesViewPresented: Bool { route == .rules }
  var isSettingsViewPresented: Bool { route == .settings }
}

public struct LocationAndChatMessagesError: Error, Equatable {}

// MARK: Actions
public enum AppAction: Equatable {
  case appDelegate(AppDelegateAction)
  case onAppear
  case fetchData
  case fetchDataResponse(Result<LocationAndChatMessages, LocationsAndChatDataService.Failure>)
  case userSettingsLoaded(Result<UserSettings, NSError>)
  
  case setNavigation(tag: AppRoute.Tag?)
  case dismissSheetView
  
  case map(MapFeatureAction)
  case nextRide(NextRideAction)
  case requestTimer(RequestTimerAction)
  case settings(SettingsAction)
}

// MARK: Environment
public struct AppEnvironment {
  let date: () -> Date
  let userDefaultsClient: UserDefaultsClient
  let nextRideService: NextRideService
  let service: LocationsAndChatDataService
  let idProvider: IDProvider
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let backgroundQueue: AnySchedulerOf<DispatchQueue>
  let locationManager: ComposableCoreLocation.LocationManager
  let uiApplicationClient: UIApplicationClient
  let fileClient: FileClient
  public var setUserInterfaceStyle: (UIUserInterfaceStyle) -> Effect<Never, Never>
  
  public init(
    service: LocationsAndChatDataService = .live(),
    idProvider: IDProvider = .live(),
    mainQueue: AnySchedulerOf<DispatchQueue> = .main,
    backgroundQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue(label: "background-queue").eraseToAnyScheduler(),
    locationManager: ComposableCoreLocation.LocationManager = .live,
    nextRideService: NextRideService = .live(),
    userDefaultsClient: UserDefaultsClient = .live(),
    date: @escaping () -> Date = Date.init,
    uiApplicationClient: UIApplicationClient,
    fileClient: FileClient = .live,
    setUserInterfaceStyle: @escaping (UIUserInterfaceStyle) -> Effect<Never, Never>
  ) {
    self.service = service
    self.idProvider = idProvider
    self.mainQueue = mainQueue
    self.backgroundQueue = backgroundQueue
    self.locationManager = locationManager
    self.nextRideService = nextRideService
    self.userDefaultsClient = userDefaultsClient
    self.date = date
    self.uiApplicationClient = uiApplicationClient
    self.fileClient = fileClient
    self.setUserInterfaceStyle = setUserInterfaceStyle
  }
}

extension AppEnvironment {
  public static let live = Self(
    service: .live(),
    idProvider: .live(),
    mainQueue: .main,
    uiApplicationClient: .live,
    setUserInterfaceStyle: { userInterfaceStyle in
      .fireAndForget {
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
      }
    }
  )
}

// MARK: Reducer

/// Holds the logic for the AppFeature
public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  mapFeatureReducer.pullback(
    state: \.mapFeatureState,
    action: /AppAction.map,
    environment: {
      MapFeatureEnvironment(
        locationManager: $0.locationManager,
        mainQueue: $0.mainQueue
      )
    }
  ),
  requestTimerReducer.pullback(
    state: \.requestTimer,
    action: /AppAction.requestTimer,
    environment: { global in
      RequestTimerEnvironment(
        mainQueue: global.mainQueue
      )
    }
  ),
  nextRideReducer.pullback(
    state: \.nextRideState,
    action: /AppAction.nextRide,
    environment: { global in
      NextRideEnvironment(
        service: global.nextRideService,
        store: global.userDefaultsClient,
        now: global.date,
        mainQueue: global.mainQueue,
        coordinateObfuscator: .live
      )
    }
  ),
  settingsReducer.pullback(
    state: \.settingsState,
    action: /AppAction.settings,
    environment: { global in SettingsEnvironment(
      uiApplicationClient: global.uiApplicationClient,
      setUserInterfaceStyle: global.setUserInterfaceStyle,
      fileClient: global.fileClient,
      backgroundQueue: global.backgroundQueue,
      mainQueue: global.mainQueue
    ) }
  ),
  Reducer { state, action, environment in
    switch action {
    case let .appDelegate(appDelegateAction):
      return .none
      
    case .onAppear:
      return .merge(
        environment.fileClient
          .loadUserSettings()
          .map(AppAction.userSettingsLoaded),
        Effect(value: .map(.onAppear)),
        Effect(value: .requestTimer(.startTimer))
      )
      
    case .fetchData:
      struct GetLocationsId: Hashable {}
      let postBody = SendLocationAndChatMessagesPostBody(
        device: environment.idProvider.id(),
        location: state.settingsState.userSettings.enableObservationMode
          ? nil
          : Location(state.mapFeatureState.location)
      )
      return environment.service
        .getLocations(postBody)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(AppAction.fetchDataResponse)
        .cancellable(id: GetLocationsId())
      
    case let .fetchDataResponse(.success(response)):
      state.locationsAndChatMessages = .success(response)
      state.mapFeatureState.riders = response.riders
      return .none
      
    case let .fetchDataResponse(.failure(error)):
      Logger.logger.info("FetchData failed: \(error)")
      state.locationsAndChatMessages = .failure(.init())
      return .none
      
    case let .map(mapFeatureAction):
      switch mapFeatureAction {
      case let .locationManager(locationManagerAction):
        switch locationManagerAction {
          
        case .didUpdateLocations:
          if !state.didResolveInitialLocation {
            state.didResolveInitialLocation.toggle()
            if let coordinate = Coordinate(state.mapFeatureState.location) {
              return .merge(
                Effect(value: .fetchData),
                Effect(value: .nextRide(.getNextRide(coordinate)))
              )
            } else {
              return Effect(value: .fetchData)
            }
          } else {
            return .none
          }
          
        default:
          return .none
        }
      default:
        return .none
      }
      
    case let .nextRide(nextRideAction):
      switch nextRideAction {
      case let .setNextRide(ride):
        state.mapFeatureState.nextRide = ride
        return .future { _ in
//          environment.infoBannerPresenter.show(
//            .criticalMass(
//              message: ride.titleAndTime,
//              subTitle: ride.location,
//              action: { callback(.success(.map(.focusNextRide))) }
//            )
//          )
        }
      default:
        return .none
      }
      
    case let .userSettingsLoaded(result):
      state.settingsState.userSettings = (try? result.get()) ?? UserSettings()
      return .merge(
        environment.setUserInterfaceStyle(state.settingsState.userSettings.colorScheme.userInterfaceStyle)
          // NB: This is necessary because UIKit needs at least one tick of the run loop before we
          //     can set the user interface style.
          .subscribe(on: environment.mainQueue)
          .fireAndForget()
      )
      
    case .setNavigation(tag: let tag):
      switch tag {
      case .chat:
        state.route = .chat
      case .rules:
        state.route = .rules
      case .settings:
        state.route = .settings
      case .none:
        state.route = .none
      }
      return .none
      
    case .dismissSheetView:
      state.route = .none
      return .none
            
    case let .requestTimer(timerAction):
      switch timerAction {
      case .timerTicked:
        return Effect(value: .fetchData)
      default:
        return .none
      }
      
    case let .settings(settingsAction):
      return .none
    }
  }
)
.debug(">>>")


extension SharedModels.Location {
  /// Creates a Location object from an optional ComposableCoreLocation.Location
  init?(_ location: ComposableCoreLocation.Location?) {
    guard let location = location else {
      return nil
    }
    self = SharedModels.Location(
      coordinate: Coordinate(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      ),
      timestamp: location.timestamp.timeIntervalSince1970
    )
  }
}

extension SharedModels.Coordinate {
  /// Creates a Location object from an optional ComposableCoreLocation.Location
  init?(_ location: ComposableCoreLocation.Location?) {
    guard let location = location else {
      return nil
    }
    self = Coordinate(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
  }
}

public enum AppRoute: Equatable {
  case chat
  case rules
  case settings
  
  public enum Tag: Int {
    case chat
    case rules
    case settings
  }

  var tag: Tag {
    switch self {
    case .chat:
      return .chat
    case .rules:
      return .rules
    case .settings:
      return .settings
    }
  }
}
