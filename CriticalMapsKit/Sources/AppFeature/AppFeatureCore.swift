import ApiClient
import ChatFeature
import ComposableArchitecture
import ComposableCoreLocation
import FileClient
import IDProvider
import L10n
import Logger
import MapFeature
import MapKit
import NextRideFeature
import PathMonitorClient
import SettingsFeature
import SharedModels
import SocialFeature
import TwitterFeedFeature
import UIApplicationClient
import UserDefaultsClient

public enum AppFeature {
  // MARK: State

  public struct State: Equatable {
    public init(
      locationsAndChatMessages: TaskResult<LocationAndChatMessages>? = nil,
      didResolveInitialLocation: Bool = false,
      mapFeatureState: MapFeature.State = .init(
        riders: [],
        userTrackingMode: UserTrackingState(userTrackingMode: .follow)
      ),
      socialState: SocialFeature.State = .init(),
      settingsState: SettingsFeature.State = .init(),
      nextRideState: NextRideFeature.State = .init(),
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
    
    public var locationsAndChatMessages: TaskResult<LocationAndChatMessages>?
    public var didResolveInitialLocation = false
    
    // Children states
    public var mapFeatureState = MapFeature.State(
      riders: [],
      userTrackingMode: UserTrackingState(userTrackingMode: .follow)
    )
    public var socialState = SocialFeature.State()
    public var settingsState = SettingsFeature.State()
    public var nextRideState = NextRideFeature.State()
    public var requestTimer = RequestTimerState()
      
    // Navigation
    public var route: AppRoute?
    public var isChatViewPresented: Bool { route == .chat }
    public var isRulesViewPresented: Bool { route == .rules }
    public var isSettingsViewPresented: Bool { route == .settings }
    
    public var chatMessageBadgeCount: UInt = 0
    public var hasConnectivity = true

    @BindableState
    public var presentEventsBottomSheet = false
    public var alert: AlertState<Action>?
  }
  
  // MARK: Actions

  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case appDelegate(AppDelegateAction)
    case onAppear
    case onDisappear
    case fetchData
    case fetchDataResponse(TaskResult<LocationAndChatMessages>)
    case userSettingsLoaded(Result<UserSettings, NSError>)
    case observeConnection
    case observeConnectionResponse(NetworkPath)

    case setEventsBottomSheet(Bool)
    case setNavigation(tag: AppRoute.Tag?)
    case dismissSheetView
    case presentObservationModeAlert
    case setObservationMode(Bool)
    case dismissAlert
    
    case map(MapFeature.Action)
    case nextRide(NextRideFeature.Action)
    case requestTimer(RequestTimerAction)
    case settings(SettingsFeature.Action)
    case social(SocialFeature.Action)
  }

  // MARK: Environment

  public struct Environment {
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
    let pathMonitorClient: PathMonitorClient
    
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
      setUserInterfaceStyle: @escaping (UIUserInterfaceStyle) -> Effect<Never, Never>,
      pathMonitorClient: PathMonitorClient = .live(queue: .main)
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
      self.pathMonitorClient = pathMonitorClient
    }
  }
  
  // MARK: Reducer

  struct ObserveConnectionIdentifier: Hashable {}

  /// Holds the logic for the AppFeature to update state and execute side effects
  public static let reducer = Reducer<State, Action, Environment>.combine(
    MapFeature.reducer.pullback(
      state: \.mapFeatureState,
      action: /AppFeature.Action.map,
      environment: {
        MapFeature.Environment(
          locationManager: $0.locationManager,
          mainQueue: $0.mainQueue
        )
      }
    ),
    requestTimerReducer.pullback(
      state: \.requestTimer,
      action: /AppFeature.Action.requestTimer,
      environment: {
        RequestTimerEnvironment(
          mainQueue: $0.mainQueue
        )
      }
    ),
    NextRideFeature.reducer.pullback(
      state: \.nextRideState,
      action: /AppFeature.Action.nextRide,
      environment: {
        NextRideFeature.Environment(
          service: $0.nextRideService,
          store: $0.userDefaultsClient,
          now: $0.date,
          mainQueue: $0.mainQueue,
          coordinateObfuscator: .live
        )
      }
    ),
    AnyReducer { _ in
      SettingsFeature()
    }
    .pullback(
      state: \.settingsState,
      action: /AppFeature.Action.settings,
      environment: { $0 }
    ),
    AnyReducer { _ in SocialFeature() }
      .pullback(
        state: \.socialState,
        action: /AppFeature.Action.social,
        environment: { $0 }
      ),
    Reducer { state, action, environment in
      switch action {
      case .binding:
        return .none
        
      case let .appDelegate(appDelegateAction):
        return .none
        
      case .onAppear:
        var effects: [Effect<Action, Never>] = [
          Effect(value: .observeConnection),
          environment.fileClient
            .loadUserSettings()
            .map(Action.userSettingsLoaded),
          Effect(value: .map(.onAppear)),
          Effect(value: .requestTimer(.startTimer))
        ]
        if !environment.userDefaultsClient.didShowObservationModePrompt() {
          effects.append(
            Effect.run { send in
              try? await environment.mainQueue.sleep(for: .seconds(3))
              await send.send(.presentObservationModeAlert)
            }
          )
        }
        
        return .merge(effects)
        
      case .onDisappear:
        return Effect.cancel(id: ObserveConnectionIdentifier())
        
      case .fetchData:
        struct GetLocationsId: Hashable {}
        let postBody = SendLocationAndChatMessagesPostBody(
          device: environment.idProvider.id(),
          location: state.settingsState.userSettings.enableObservationMode
            ? nil
            : Location(state.mapFeatureState.location)
        )
        
        guard state.hasConnectivity else {
          logger.info("AppAction.fetchData not executed. Not connected to internet")
          return .none
        }
        return .task {
          await .fetchDataResponse(
            TaskResult {
              try await environment.service.getLocationsAndSendMessages(postBody)
            }
          )
        }
        
      case let .fetchDataResponse(.success(response)):
        state.locationsAndChatMessages = .success(response)
        
        state.socialState.chatFeautureState.chatMessages = .results(response.chatMessages)
        state.mapFeatureState.riderLocations = response.riderLocations
        
        if !state.isChatViewPresented {
          let cachedMessages = response.chatMessages
            .values
            .sorted(by: \.timestamp)
          
          let unreadMessagesCount = UInt(
            cachedMessages
              .filter { $0.timestamp > environment.userDefaultsClient.chatReadTimeInterval() }
              .count
          )
          state.chatMessageBadgeCount = unreadMessagesCount
        }
        
        return .none
        
      case let .fetchDataResponse(.failure(error)):
        logger.info("FetchData failed: \(error)")
        state.locationsAndChatMessages = .failure(error)
        return .none
        
      case .observeConnection:
        return .run { send in
          for await path in await environment.pathMonitorClient.networkPathPublisher() {
            await send(.observeConnectionResponse(path))
          }
        }
        .cancellable(id: ObserveConnectionIdentifier())
        
      case let .observeConnectionResponse(networkPath):
        state.hasConnectivity = networkPath.status == .satisfied
        state.nextRideState.hasConnectivity = state.hasConnectivity
        logger.info("Is connected: \(state.hasConnectivity)")
        return .none

      case let .map(mapFeatureAction):
        switch mapFeatureAction {
        case let .locationManager(locationManagerAction):
          switch locationManagerAction {
          case .didUpdateLocations:
            if !state.didResolveInitialLocation {
              state.didResolveInitialLocation.toggle()
              if let coordinate = Coordinate(state.mapFeatureState.location), state.settingsState.userSettings.rideEventSettings.isEnabled {
                return Effect.concatenate(
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

        case .focusNextRide:
          if state.presentEventsBottomSheet {
            return Effect(value: .setEventsBottomSheet(false))
          } else {
            return .none
          }

        default:
          return .none
        }
        
      case let .nextRide(nextRideAction):
        switch nextRideAction {
        case let .setNextRide(ride):
          state.mapFeatureState.nextRide = ride
          return Effect.run { send in
            await send.send(.map(.setNextRideBannerVisible(true)))
            try? await environment.mainQueue.sleep(for: .seconds(1))
            await send.send(.map(.setNextRideBannerExpanded(true)))
            try? await environment.mainQueue.sleep(for: .seconds(8))
            await send.send(.map(.setNextRideBannerExpanded(false)))
          }
          
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

      case let .setNavigation(tag: tag):
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

      case let .setEventsBottomSheet(value):
        if value {
          state.mapFeatureState.rideEvents = state.nextRideState.rideEvents
        } else {
          state.mapFeatureState.rideEvents = []
          state.mapFeatureState.eventCenter = nil
        }
        state.presentEventsBottomSheet = value
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
        
      case .presentObservationModeAlert:
        state.alert = .viewingModeAlert
        return .none
        
      case let .setObservationMode(value):
        state.settingsState.userSettings.enableObservationMode = value
        return .merge(
          environment.fileClient
            .saveUserSettings(userSettings: state.settingsState.userSettings, on: environment.mainQueue)
            .fireAndForget(),
          environment.userDefaultsClient.setDidShowObservationModePrompt(true)
            .fireAndForget()
        )
        
      case .dismissAlert:
        state.alert = nil
        return .none
        
      case let .social(socialAction):
        switch socialAction {
        case .chat(.onAppear):
          state.chatMessageBadgeCount = 0
          return .none
        
        default:
          return .none
        }
        
      case let .settings(settingsAction):
        switch settingsAction {
        case let .rideevent(.setRideEventsEnabled(isEnabled)):
          if !isEnabled {
            return Effect(value: .map(.setNextRideBannerVisible(false)))
          } else {
            return .none
          }
          
        default:
          return .none
        }
      }
    }
  )
  .binding()
  .onChange(of: \.settingsState.userSettings.rideEventSettings) { rideEventSettings, state, _, environment in
    struct RideEventSettingsChange: Hashable {}

    // fetch next ride after settings have changed
    guard let coordinate = Coordinate(state.mapFeatureState.location), rideEventSettings.isEnabled else {
      return .none
    }
    
    return Effect(value: .nextRide(.getNextRide(coordinate)))
      .debounce(id: RideEventSettingsChange(), for: 1.5, scheduler: environment.mainQueue)
  }
  .onChange(of: \.mapFeatureState.location) { location, state, _, _ in
    state.nextRideState.userLocation = Coordinate(location)
    return .none
  }
}

// MARK: - Helper

public extension AppFeature.Environment {
  static let live = Self(
    service: .live(),
    idProvider: .live(),
    mainQueue: .main,
    uiApplicationClient: .live,
    setUserInterfaceStyle: { userInterfaceStyle in
      .fireAndForget {
        UIApplication.shared.firstWindowSceneWindow?.overrideUserInterfaceStyle = userInterfaceStyle
      }
    }
  )
}

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

public extension AlertState where Action == AppFeature.Action {
  static let viewingModeAlert = Self(
    title: .init(L10n.Settings.Observationmode.title),
    message: .init(L10n.AppCore.ViewingModeAlert.message),
    buttons: [
      .default(.init(L10n.AppCore.ViewingModeAlert.riding), action: .send(.setObservationMode(false))),
      .default(.init(L10n.AppCore.ViewingModeAlert.watching), action: .send(.setObservationMode(true)))
    ]
  )
}
