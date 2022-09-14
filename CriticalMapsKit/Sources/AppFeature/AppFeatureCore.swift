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
import SharedEnvironment
import SharedModels
import SocialFeature
import TwitterFeedFeature
import UIApplicationClient
import UserDefaultsClient

public struct AppFeature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.fileClient) public var fileClient
  @Dependency(\.locationAndChatService) public var locationsAndChatDataService
  @Dependency(\.uuid) public var uuid
  @Dependency(\.date) public var date
  @Dependency(\.userDefaultsClient) public var userDefaultsClient
  @Dependency(\.nextRideService) public var nextRideService
  @Dependency(\.idProvider) public var idProvider
  @Dependency(\.mainQueue) public var mainQueue
  @Dependency(\.backgroundQueue) public var backgroundQueue
  @Dependency(\.locationManager) public var locationManager
  @Dependency(\.uiApplicationClient) public var uiApplicationClient
  @Dependency(\.setUserInterfaceStyle) public var setUserInterfaceStyle
  @Dependency(\.pathMonitorClient) public var pathMonitorClient
  
  // MARK: State

  public struct State: Equatable {
    public init(
      locationsAndChatMessages: TaskResult<LocationAndChatMessages>? = nil,
      didResolveInitialLocation: Bool = false,
      mapFeatureState: MapFeature.State = .init(
        riders: [],
        userTrackingMode: UserTrackingFeature.State(userTrackingMode: .follow)
      ),
      socialState: SocialFeature.State = .init(),
      settingsState: SettingsFeature.State = .init(),
      nextRideState: NextRideFeature.State = .init(),
      requestTimer: RequestTimer.State = .init(),
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
      userTrackingMode: UserTrackingFeature.State(userTrackingMode: .follow)
    )
    public var socialState = SocialFeature.State()
    public var settingsState = SettingsFeature.State()
    public var nextRideState = NextRideFeature.State()
    public var requestTimer = RequestTimer.State()
      
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
    case appDelegate(AppDelegate.Action)
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
    case requestTimer(RequestTimer.Action)
    case settings(SettingsFeature.Action)
    case social(SocialFeature.Action)
  }
  
  // MARK: Reducer

  struct ObserveConnectionIdentifier: Hashable {}

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Scope(state: \.requestTimer, action: /AppFeature.Action.requestTimer) {
      RequestTimer()
    }
    
    Scope(state: \.mapFeatureState, action: /AppFeature.Action.map) {
      MapFeature()
    }
    
    Scope(state: \.nextRideState, action: /AppFeature.Action.nextRide) {
      NextRideFeature()
    }
    
    Scope(state: \.settingsState, action: /AppFeature.Action.settings) {
      SettingsFeature()
    }
    
    Scope(state: \.socialState, action: /AppFeature.Action.social) {
      SocialFeature()
    }
    
    /// Holds the logic for the AppFeature to update state and execute side effects
    Reduce<State, Action> { state, action in
      switch action {
      case .binding:
        return .none
        
      case .appDelegate:
        return .none
        
      case .onAppear:
        var effects: [Effect<Action, Never>] = [
          Effect(value: .observeConnection),
          fileClient
            .loadUserSettings()
            .map(Action.userSettingsLoaded),
          Effect(value: .map(.onAppear)),
          Effect(value: .requestTimer(.startTimer))
        ]
        if !userDefaultsClient.didShowObservationModePrompt() {
          effects.append(
            Effect.run { send in
              try? await mainQueue.sleep(for: .seconds(3))
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
          device: idProvider.id(),
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
              try await locationsAndChatDataService.getLocationsAndSendMessages(postBody)
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
              .filter { $0.timestamp > userDefaultsClient.chatReadTimeInterval() }
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
          for await path in await pathMonitorClient.networkPathPublisher() {
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
            
            // synchronize with nextRideState
            state.nextRideState.userLocation = Coordinate(state.mapFeatureState.location)
            
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
            try? await mainQueue.sleep(for: .seconds(1))
            await send.send(.map(.setNextRideBannerExpanded(true)))
            try? await mainQueue.sleep(for: .seconds(8))
            await send.send(.map(.setNextRideBannerExpanded(false)))
          }
          
        default:
          return .none
        }
        
      case let .userSettingsLoaded(result):
        state.settingsState.userSettings = (try? result.get()) ?? UserSettings()
        return .merge(
          setUserInterfaceStyle(state.settingsState.userSettings.appearanceSettings.colorScheme.userInterfaceStyle)
            // NB: This is necessary because UIKit needs at least one tick of the run loop before we
            //     can set the user interface style.
            .subscribe(on: mainQueue)
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
          fileClient
            .saveUserSettings(userSettings: state.settingsState.userSettings, on: mainQueue)
            .fireAndForget(),
          userDefaultsClient.setDidShowObservationModePrompt(true)
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
            guard let coordinate = Coordinate(state.mapFeatureState.location), state.settingsState.userSettings.rideEventSettings.isEnabled else {
              return .none
            }
            struct RideEventSettingsChange: Hashable {}
            
            return Effect(value: .nextRide(.getNextRide(coordinate)))
              .debounce(id: RideEventSettingsChange(), for: 1.5, scheduler: mainQueue)
          }
          
        default:
          return .none
        }
      }
    }
  }
}

// MARK: - Helper

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
