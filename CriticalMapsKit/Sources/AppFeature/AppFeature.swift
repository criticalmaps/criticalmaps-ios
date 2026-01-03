import ApiClient
import ChatFeature
import ComposableArchitecture
import ComposableCoreLocation
import FeedbackGeneratorClient
import IDProvider
import L10n
import MapFeature
import MapKit
import MastodonFeedFeature
import NextRideFeature
import os
import SettingsFeature
import SharedModels
import SocialFeature
import struct SwiftUI.PresentationDetent
import UIApplicationClient
import UserDefaultsClient

@Reducer
public struct AppFeature: Sendable { // swiftlint:disable:this type_body_length
  public init() {}
  
  @Reducer
  public enum Destination: Sendable {
    case social(SocialFeature)
    case settings(SettingsFeature)
    case alert(AlertState<Alert>)
    
    @CasePathable
    public enum Alert: Equatable, Sendable {
      case setObservationMode(enabled: Bool)
    }
  }
  
  // MARK: State

  @ObservableState
  public struct State: Equatable {
    public var riderLocations: [Rider]
    public var isRequestingRiderLocations = false
    public var didRequestNextRide = false
    public var socialState = SocialFeature.State()
    public var settingsState = SettingsFeature.State()
    public var nextRideState = NextRideFeature.State()
    public var requestTimer = RequestTimer.State()
      
    // Navigation
    @Presents var destination: Destination.State?
    public var eventListPresentation: PresentationDetent = .fraction(0.3)
    public var isEventListPresented = false

    public var chatMessageBadgeCount: UInt = 0
    public var isCurrentLocationInPrivacyZone = false
    
    @Shared(.userSettings) var userSettings
    @Shared(.rideEventSettings) var rideEventSettings
    @Shared(.appearanceSettings) var appearanceSettings
    @Shared(.connectionError) var connectionError
    @Shared(.privacyZoneSettings) var privacyZoneSettings
    
    public init(
      locationsAndChatMessages: [Rider] = [],
      mapFeatureState: MapFeatureState = .init(
        riders: [],
        userTrackingMode: UserTrackingFeature.State()
      ),
      socialState: SocialFeature.State = .init(),
      settingsState: SettingsFeature.State = .init(),
      nextRideState: NextRideFeature.State = .init(),
      requestTimer: RequestTimer.State = .init(),
      chatMessageBadgeCount: UInt = 0
    ) {
      riderLocations = locationsAndChatMessages
      self.mapFeatureState = mapFeatureState
      self.socialState = socialState
      self.settingsState = settingsState
      self.nextRideState = nextRideState
      self.requestTimer = requestTimer
      self.chatMessageBadgeCount = chatMessageBadgeCount
    }

    public var mapFeatureState: MapFeatureState

    public var ridersCount: String {
      let count = mapFeatureState.visibleRidersCount ?? 0
      return count.formatted(.number.grouping(.automatic))
    }

    var shouldShowNextRideBanner: Bool {
      mapFeatureState.isNextRideBannerVisible &&
        rideEventSettings.isEnabled
    }
  }
  
  // MARK: Actions

  @CasePathable
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    case onAppear
    case onDisappear
    case fetchLocations
    case fetchLocationsResponse(Result<[Rider], any Error>)
    case postLocation
    case postLocationResponse(Result<ApiResponse, any Error>)
    case fetchChatMessages
    case fetchChatMessagesResponse(Result<[ChatMessage], any Error>)
    case onRideSelectedFromBottomSheet(SharedModels.Ride)
    case presentObservationModeAlert
    
    case socialButtonTapped
    case settingsButtonTapped
    case didTapNextRideOverlayButton
    case dismissEventList
    case dismissDestination
    
    case map(MapFeatureAction)
    case nextRide(NextRideFeature.Action)
    case requestTimer(RequestTimer.Action)
  }
  
  // MARK: Reducer
  
  @Dependency(\.apiService) var apiService
  @Dependency(\.uuid) var uuid
  @Dependency(\.date) var date
  @Dependency(\.userDefaultsClient) var userDefaultsClient
  @Dependency(\.nextRideService) var nextRideService
  @Dependency(\.idProvider) var idProvider
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.continuousClock) var clock
  @Dependency(\.locationManager) var locationManager
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.uiApplicationClient) var uiApplicationClient

  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.requestTimer, action: \.requestTimer) {
      RequestTimer()
    }
    
    Scope(state: \.mapFeatureState, action: \.map) {
      MapFeature()
    }
    
    Scope(state: \.nextRideState, action: \.nextRide) {
      NextRideFeature()
    }
    
    /// Holds the logic for the AppFeature to update state and execute side effects
    Reduce { state, action in
      switch action {
      case let .onRideSelectedFromBottomSheet(ride):
        return .merge(
          .send(.map(.focusRideEvent(ride.coordinate))),
          .run { _ in await feedbackGenerator.selectionChanged() }
        )
        
      case .onAppear:
        var effects: [Effect<Action>] = [
          .send(.map(.onAppear)),
          .send(.requestTimer(.startTimer)),
          .run { _ in
            await userDefaultsClient.setSessionID(uuid().uuidString)
          },
          .run { [style = state.appearanceSettings.colorScheme.userInterfaceStyle] _ in
            await uiApplicationClient.setUserInterfaceStyle(style)
          },
          .run { send in
            await withThrowingTaskGroup(of: Void.self) { group in
              group.addTask {
                await send(.fetchChatMessages)
              }
              group.addTask {
                await send(.fetchLocations)
              }
            }
          },
          .run { _ in
            await feedbackGenerator.prepare()
          }
        ]
        if !userDefaultsClient.didShowObservationModePrompt {
          effects.append(
            .run { send in
              try? await clock.sleep(for: .seconds(3))
              await send(.presentObservationModeAlert)
            }
          )
        }
        
        return .merge(effects)
        
      case .onDisappear:
        return .none
        
      case .fetchLocations:
        state.isRequestingRiderLocations = true
        return .run { send in
          await send(
            .fetchLocationsResponse(
              Result {
                try await apiService.getRiders()
              }
            )
          )
        }
        
      case .fetchChatMessages:
        return .run { send in
          await send(
            .fetchChatMessagesResponse(
              Result {
                try await apiService.getChatMessages()
              }
            )
          )
        }
        
      case let .fetchChatMessagesResponse(.success(messages)):
        state.socialState.chatFeatureState.chatMessages = .results(messages)
        if case .social = state.destination {
          let cachedMessages = messages.sorted(by: \.timestamp)
          
          let unreadMessagesCount = UInt(
            cachedMessages
              .count(where: { $0.timestamp > userDefaultsClient.chatReadTimeInterval })
          )
          state.chatMessageBadgeCount = unreadMessagesCount
        }
        return .none
        
      case let .fetchChatMessagesResponse(.failure(error)):
        state.socialState.chatFeatureState.chatMessages = .error(
          .init(
            title: L10n.error,
            body: L10n.Social.Error.fetchMessages,
            error: .init(error: error)
          )
        )
        
        Logger.reducer.debug("FetchLocation failed: \(error)")
        return .none
        
      case let .fetchLocationsResponse(.success(response)):
        state.isRequestingRiderLocations = false
        state.riderLocations = response
        state.mapFeatureState.riderLocations = response
        return .none
        
      case let .fetchLocationsResponse(.failure(error)):
        state.isRequestingRiderLocations = false
        Logger.reducer.debug("FetchLocation failed: \(error)")
        state.riderLocations = []
        return .none
        
      case .postLocation:
        guard !state.userSettings.isObservationModeEnabled else {
          return .none
        }
        
        // Check if current location is in a privacy zone
        if let currentLocation = state.mapFeatureState.location,
           state.privacyZoneSettings.isLocationInPrivacyZone(currentLocation.coordinate)
        {
          Logger.reducer.debug("Location not posted - user is in a privacy zone")
          return .none
        }
        
        let postBody = SendLocationPostBody(
          device: idProvider.id(),
          location: state.mapFeatureState.location
        )
        return .run { send in
          await send(
            .postLocationResponse(
              Result {
                try await apiService.postRiderLocation(postBody)
              }
            )
          )
        }
        
      case .postLocationResponse(.success):
        return .none
        
      case let .postLocationResponse(.failure(error)):
        Logger.reducer.debug("Failed to post location. Error: \(error.localizedDescription)")
        return .none
        
      case let .map(mapFeatureAction):
        switch mapFeatureAction {
        case .focusRideEvent, .focusNextRide:
          return .none
          
        case .locationManager(.didUpdateLocations):
          state.nextRideState.userLocation = state.mapFeatureState.location?.coordinate
          
          if let currentLocation = state.mapFeatureState.location {
            let isLocationInPrivacyZone = state.privacyZoneSettings.isLocationInPrivacyZone(currentLocation.coordinate)
            state.isCurrentLocationInPrivacyZone = isLocationInPrivacyZone
          }
          
          let coordinate = state.mapFeatureState.location?.coordinate
          let isRideEventsEnabled = state.rideEventSettings.isEnabled
          if isRideEventsEnabled, let coordinate, !state.didRequestNextRide {
            state.didRequestNextRide = true
            return .run { send in
              await send(.nextRide(.getNextRide(coordinate)))
            }
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
          return .run { send in
            await send(.map(.setNextRideBannerVisible(true)), animation: .snappy)
          }
          
        default:
          return .none
        }
        
      case let .requestTimer(timerAction):
        switch timerAction {
        case .halfwayPoint:
          // At 30 seconds, post user location
          return .send(.postLocation)

        case .fullCycle:
          // At 60 seconds, fetch fresh data
          return .run { [destination = state.destination] send in
            await withThrowingTaskGroup(of: Void.self) { group in
              group.addTask {
                await send(.fetchLocations)
              }
              if case .social = destination {
                group.addTask {
                  await send(.fetchChatMessages)
                }
              }
            }
          }

        default:
          return .none
        }
        
      case .socialButtonTapped:
        state.destination = .social(SocialFeature.State())
        return .none
        
      case .settingsButtonTapped:
        state.destination = .settings(SettingsFeature.State())
        return .none
        
      case .dismissDestination:
        state.destination = nil
        return .none
        
      case .presentObservationModeAlert:
        state.destination = .alert(
          AlertState(
            title: {
              TextState(verbatim: L10n.Settings.Observationmode.title)
            },
            actions: {
              ButtonState(
                action: .setObservationMode(enabled: false),
                label: { TextState(L10n.AppCore.ViewingModeAlert.riding) }
              )
              ButtonState(
                action: .setObservationMode(enabled: true),
                label: { TextState(L10n.AppCore.ViewingModeAlert.watching) }
              )
            },
            message: { TextState(L10n.AppCore.ViewingModeAlert.message) }
          )
        )
        return .run { _ in
          await userDefaultsClient.setDidShowObservationModePrompt(true)
        }
        
      case let .destination(.presented(.alert(alertAction))):
        switch alertAction {
        case let .setObservationMode(enabled: mode):
          state.$userSettings.withLock { $0.isObservationModeEnabled = mode }
          return .none
        }
        
      case let .destination(.presented(.settings(settingsAction))):
        switch settingsAction {
        case .destination(.presented(.rideEventSettings)):
          guard
            let coordinate = state.mapFeatureState.location?.coordinate,
            state.rideEventSettings.isEnabled
          else {
            return .none
          }
          enum RideEventCancelID {
            case settingsChange
          }
          return .send(.nextRide(.getNextRide(coordinate)))
            .debounce(
              id: RideEventCancelID.settingsChange,
              for: 2,
              scheduler: mainQueue
            )
          
        default:
          return .none
        }
        
      case .destination(.presented(.social(.chat(.onAppear)))):
        state.chatMessageBadgeCount = 0
        return .none
        
      case .destination:
        return .none
        
      case .binding(\.rideEventSettings.rideEvents):
        guard
          let coordinate = state.mapFeatureState.location?.coordinate,
          state.rideEventSettings.isEnabled
        else {
          return .none
        }
        enum RideEventCancelID {
          case settingsChange
        }
        return .send(.nextRide(.getNextRide(coordinate)))
          .debounce(
            id: RideEventCancelID.settingsChange,
            for: 2,
            scheduler: mainQueue
          )
        
      case .didTapNextRideOverlayButton:
        state.isEventListPresented.toggle()
        
        var effects: [Effect<Action>] = [
          .run { _ in await feedbackGenerator.selectionChanged() }
        ]
        if state.isEventListPresented {
          effects.append(.send(.map(.focusNextRide(state.nextRideState.nextRide?.coordinate))))
        }
        return .merge(effects)
      
      case .dismissEventList:
        state.isEventListPresented = false
        return .none
        
      case .binding:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
    .onChange(of: \.isEventListPresented) { _, newValue in
      Reduce { state, _ in
        if !newValue {
          state.mapFeatureState.rideEvents = []
          state.mapFeatureState.eventCenter = nil
        } else {
          state.mapFeatureState.rideEvents = state.nextRideState.rideEvents
        }
        return .none
      }
    }
  }
}

// MARK: - Helper

extension AppFeature.Destination.State: Equatable, Sendable {}

extension SharedModels.Location {
  /// Creates a Location object from an optional ComposableCoreLocation.Location
  init?(_ location: ComposableCoreLocation.Location?) {
    guard let location else {
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
    guard let location else {
      return nil
    }
    self = Coordinate(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
  }
}

private extension Logger {
  /// Using your bundle identifier is a great way to ensure a unique identifier.
  private static let subsystem = "AppFeature"
  
  /// Logs the view cycles like a view that appeared.
  static let reducer = Logger(
    subsystem: subsystem,
    category: "Reducer"
  )
}
