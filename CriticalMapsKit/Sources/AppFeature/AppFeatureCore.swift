import ApiClient
import ChatFeature
import ComposableArchitecture
import ComposableCoreLocation
import FileClient
import Logger
import MapKit
import MapFeature
import NextRideFeature
import IDProvider
import SettingsFeature
import SharedModels
import SocialFeature
import TwitterFeedFeature
import UserDefaultsClient
import UIApplicationClient

// MARK: State
public struct AppState: Equatable {
  public init(
    locationsAndChatMessages: Result<LocationAndChatMessages, NSError>? = nil,
    didResolveInitialLocation: Bool = false,
    mapFeatureState: MapFeatureState = MapFeatureState(
      riders: [],
      userTrackingMode: UserTrackingState(userTrackingMode: .follow)
    ),
    socialState: SocialState = SocialState(),
    settingsState: SettingsState = SettingsState(),
    nextRideState: NextRideState = NextRideState(),
    requestTimer: RequestTimerState = RequestTimerState(),
    route: AppRoute? = nil,
    chatMessageBadgeCount: UInt = 0
  ) {
    self.locationsAndChatMessages = locationsAndChatMessages
    self.didResolveInitialLocation = didResolveInitialLocation
    self.mapFeatureState = mapFeatureState
    self.socialState = socialState
    self.settingsState = settingsState
    self.nextRideState = nextRideState
    self.requestTimer = requestTimer
    self.route = route
    self.chatMessageBadgeCount = chatMessageBadgeCount
  }
  
  public var locationsAndChatMessages: Result<LocationAndChatMessages, NSError>?
  public var didResolveInitialLocation: Bool = false
  
  // Children states
  public var mapFeatureState: MapFeatureState = MapFeatureState(
    riders: [],
    userTrackingMode: UserTrackingState(userTrackingMode: .follow)
  )
  public var socialState = SocialState()
  public var settingsState = SettingsState()
  public var nextRideState = NextRideState()
  public var requestTimer = RequestTimerState()
    
  // Navigation
  public var route: AppRoute?
  public var isChatViewPresented: Bool { route == .chat }
  public var isRulesViewPresented: Bool { route == .rules }
  public var isSettingsViewPresented: Bool { route == .settings }
  
  public var chatMessageBadgeCount: UInt = 0
}

// MARK: Actions
public enum AppAction: Equatable {
  case appDelegate(AppDelegateAction)
  case onAppear
  case fetchData
  case fetchDataResponse(Result<LocationAndChatMessages, NSError>)
  case userSettingsLoaded(Result<UserSettings, NSError>)
  
  case setNavigation(tag: AppRoute.Tag?)
  case dismissSheetView
  
  case map(MapFeatureAction)
  case nextRide(NextRideAction)
  case requestTimer(RequestTimerAction)
  case settings(SettingsAction)
  case social(SocialAction)
}

// MARK: Environment
public struct AppEnvironment {
  let locationsAndChatDataService: LocationsAndChatDataService
  let uuid: () -> UUID
  let date: () -> Date
  var userDefaultsClient: UserDefaultsClient
  var nextRideService: NextRideService
  var service: LocationsAndChatDataService
  var idProvider: IDProvider
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var backgroundQueue: AnySchedulerOf<DispatchQueue>
  var locationManager: ComposableCoreLocation.LocationManager
  var uiApplicationClient: UIApplicationClient
  var fileClient: FileClient
  public var setUserInterfaceStyle: (UIUserInterfaceStyle) -> Effect<Never, Never>
  
  public init(
    locationsAndChatDataService: LocationsAndChatDataService = .live(),
    service: LocationsAndChatDataService = .live(),
    idProvider: IDProvider = .live(),
    mainQueue: AnySchedulerOf<DispatchQueue> = .main,
    backgroundQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue(label: "background-queue").eraseToAnyScheduler(),
    locationManager: ComposableCoreLocation.LocationManager = .live,
    nextRideService: NextRideService = .live(),
    userDefaultsClient: UserDefaultsClient = .live(),
    uuid: @escaping () -> UUID = UUID.init,
    date: @escaping () -> Date = Date.init,
    uiApplicationClient: UIApplicationClient,
    fileClient: FileClient = .live,
    setUserInterfaceStyle: @escaping (UIUserInterfaceStyle) -> Effect<Never, Never>
  ) {
    self.locationsAndChatDataService = locationsAndChatDataService
    self.service = service
    self.idProvider = idProvider
    self.mainQueue = mainQueue
    self.backgroundQueue = backgroundQueue
    self.locationManager = locationManager
    self.nextRideService = nextRideService
    self.userDefaultsClient = userDefaultsClient
    self.uuid = uuid
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
    )}
  ),
  socialReducer.pullback(
    state: \.socialState,
    action: /AppAction.social,
    environment: { global in
      SocialEnvironment(
        mainQueue: global.mainQueue,
        uiApplicationClient: global.uiApplicationClient,
        locationsAndChatDataService: global.locationsAndChatDataService,
        idProvider: global.idProvider,
        uuid: global.uuid,
        date: global.date,
        userDefaultsClient: global.userDefaultsClient
      )
    }
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
        .getLocationsAndSendMessages(postBody)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(AppAction.fetchDataResponse)
        .cancellable(id: GetLocationsId())
      
    case let .fetchDataResponse(.success(response)):
      state.locationsAndChatMessages = .success(response)
      
      state.socialState.chatFeautureState.chatMessages = response.chatMessages
      state.mapFeatureState.riderLocations = response.riderLocations
      
      if !state.isChatViewPresented {
        let cachedMessages = state.socialState.chatFeautureState.chatMessages
          .values
          .sorted(by: \.timestamp)
        
        let unreadMessagesCount = UInt(
          cachedMessages
            .lazy
            .filter { $0.timestamp > environment.userDefaultsClient.chatReadTimeInterval() }
            .count
        )
        state.chatMessageBadgeCount = unreadMessagesCount        
      }
      
      return .none
      
    case let .fetchDataResponse(.failure(error)):
      Logger.logger.info("FetchData failed: \(error)")
      state.locationsAndChatMessages = .failure(error)
      return .none
      
    case let .map(mapFeatureAction):
      switch mapFeatureAction {
      case let .locationManager(locationManagerAction):
        switch locationManagerAction {
          
        case .didUpdateLocations:
          if !state.didResolveInitialLocation {
            state.didResolveInitialLocation.toggle()
            if let coordinate = Coordinate(state.mapFeatureState.location), state.settingsState.userSettings.rideEventSettings.isEnabled { // TODO: Test
              return Effect.merge(
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
        return .none
        
      default:
        return .none
      }
      
    case let .userSettingsLoaded(result):
      state.settingsState.userSettings = (try? result.get()) ?? UserSettings()
      return .merge(
        environment.setUserInterfaceStyle(state.settingsState.userSettings.appearanceSettings.colorScheme.userInterfaceStyle)
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
    
    case let .social(socialAction):
      switch socialAction {
      case .chat(.onAppear):
        state.chatMessageBadgeCount = 0
        return .none
      
      default:
        return .none
      }
      
    case .settings:
      return .none
    }
  }
)


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
