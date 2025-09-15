import ComposableCoreLocation
import Foundation
import L10n
import MapKit
import SharedDependencies
import SharedModels

public typealias MapFeatureState = MapFeature.State
public typealias MapFeatureAction = MapFeature.Action

@Reducer
public struct MapFeature {
  public init() {}
  
  // MARK: State
  
  @ObservableState
  public struct State: Equatable {
    public var alert: AlertState<Action>?
    public var isRequestingCurrentLocation: Bool
    public var location: SharedModels.Location?
    public var riderLocations: [Rider]
    public var nextRide: Ride?
    public var rideEvents: [Ride] = []
    public var isObservationModeEnabled = false
    
    public var visibleRidersCount: Int?
    public var eventCenter: CoordinateRegion?
    public var userTrackingMode: UserTrackingFeature.State
    public var centerRegion: CoordinateRegion?
    public var presentShareSheet = false
    
    public var shouldAnimateTrackingMode = true
    public var isNextRideBannerVisible = false
    public var isNextRideBannerExpanded = false
    
    @Shared(.userSettings) var userSettings
    
    public init(
      alert: AlertState<Action>? = nil,
      isRequestingCurrentLocation: Bool = false,
      location: SharedModels.Location? = nil,
      riders: [Rider],
      userTrackingMode: UserTrackingFeature.State,
      nextRide: Ride? = nil,
      centerRegion: CoordinateRegion? = nil
    ) {
      self.alert = alert
      self.isRequestingCurrentLocation = isRequestingCurrentLocation
      self.location = location
      riderLocations = riders
      self.userTrackingMode = userTrackingMode
      self.nextRide = nextRide
      self.centerRegion = centerRegion
    }
  }

  @CasePathable
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case locationRequested
    case updateCenterRegion(CoordinateRegion?)
    case focusNextRide(Coordinate?)
    case focusRideEvent(Coordinate?)
    case resetCenterRegion
    case resetRideEventCenter
    case startRequestingCurrentLocation
    case setAlert(AlertState<Action>)
    
    case showShareSheet(Bool)
    case routeToEvent
    
    case setNextRideBannerVisible(Bool)
    
    case locationManager(LocationManager.Action)
    case userTracking(UserTrackingFeature.Action)
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.locationManager) var locationManager
  @Dependency(\.continuousClock) var clock
  
  enum CancelID { case locationManager }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.userTrackingMode, action: \.userTracking) {
      UserTrackingFeature()
    }
    
    Scope(state: \.self, action: \.locationManager) {
      Reduce<State, LocationManager.Action> { state, action in
        switch action {
        case .didChangeAuthorization(.authorizedAlways),
             .didChangeAuthorization(.authorizedWhenInUse):
          if state.isRequestingCurrentLocation {
            return .run { _ in
              await locationManager.requestLocation()
            }
          } else {
            return .none
          }
          
        case .didChangeAuthorization(.denied):
          if state.isRequestingCurrentLocation {
            state.alert = AlertState {
              TextState("Location makes this app better. Please consider giving us access.")
            }
            
            state.isRequestingCurrentLocation = false
          }
          return .none
          
        case let .didUpdateLocations(locations):
          state.isRequestingCurrentLocation = false
          guard let location = locations.first else { return .none }
          
          let mapLocation = Location(
            coordinate: .init(
              latitude: location.coordinate.latitude,
              longitude: location.coordinate.longitude
            ),
            timestamp: location.timestamp.timeIntervalSince1970
          )
          
          state.location = mapLocation
          return .none
          
        default:
          return .none
        }
      }
    }
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .setAlert(alert):
        state.alert = alert
        return .none
        
      case let .setNextRideBannerVisible(value):
        state.isNextRideBannerVisible = value
        return .none

      case .onAppear:
        var effects: [Effect<Action>] = [
          .run { _ in
            await locationManager.setup()
          },
          .run { send in
            await withTaskCancellation(id: CancelID.locationManager, cancelInFlight: true) {
              for await action in await locationManager.delegate() {
                await send(.locationManager(action), animation: .default)
              }
            }
          }
        ]
        let isObservationModeEnabled = state.userSettings.isObservationModeEnabled
        if !isObservationModeEnabled {
          effects.append(.send(.locationRequested))
        }
        return .merge(effects)
        
      case .startRequestingCurrentLocation:
        state.isRequestingCurrentLocation = true
        return .run { _ in
          await locationManager.requestAlwaysAuthorization()
        }
        
      case .locationRequested:
        return .run { send in
          switch await locationManager.authorizationStatus() {
          case .notDetermined:
            await send(.startRequestingCurrentLocation)

          case .restricted, .denied:
            await send(.setAlert(.goToSettingsAlert))
                        
          case .authorizedAlways, .authorizedWhenInUse:
            @Shared(.userSettings) var userSettings
            guard !userSettings.isObservationModeEnabled else {
              return
            }
            await locationManager.startUpdatingLocation()
            
          @unknown default:
            break
          }
        }

      case let .focusNextRide(coordinate):
        guard let nextRideCoordinate = coordinate else {
          return .none
        }
        state.centerRegion = CoordinateRegion(center: nextRideCoordinate.asCLLocationCoordinate)
        
        return .run { send in
          try await clock.sleep(for: .seconds(1))
          await send(.resetCenterRegion)
        }

      case let .focusRideEvent(coordinate):
        guard let coordinate else {
          return .none
        }

        state.eventCenter = CoordinateRegion(center: coordinate.asCLLocationCoordinate)
        
        return .run { send in
          try await clock.sleep(for: .seconds(1))
          await send(.resetRideEventCenter)
        }

      case .resetRideEventCenter:
        state.eventCenter = nil
        return .none

      case .resetCenterRegion:
        state.centerRegion = nil
        return .none
        
      case let .showShareSheet(value):
        state.presentShareSheet = value
        return .none
        
      case .routeToEvent:
        state.nextRide?.openInMaps()
        return .none

      case .locationManager, .userTracking, .updateCenterRegion:
        return .none
      }
    }
  }
}

// MARK: - Helper

extension LocationManager {
  /// Configures the LocationManager
  func setup() async {
    await set(
      activityType: .otherNavigation,
      allowsBackgroundLocationUpdates: true,
      desiredAccuracy: kCLLocationAccuracyBest,
      distanceFilter: 200.0,
      headingFilter: nil,
      pausesLocationUpdatesAutomatically: false,
      showsBackgroundLocationIndicator: true
    )
  }
}

public extension AlertState where Action == MapFeature.Action {
  static let goToSettingsAlert = Self(
    title: { TextState(L10n.Location.Alert.provideAccessToLocationService) },
    actions: {
      ButtonState<MapFeature.Action> { TextState(L10n.Settings.title) }
      ButtonState<MapFeature.Action> { TextState(L10n.Settings.title) }
    }
  )
  
  static let provideAuth = Self(title: { TextState(L10n.Location.Alert.provideAuth) })
  static let servicesOff = Self(title: { TextState(L10n.Location.Alert.serviceIsOff) })
  static let provideAccessToLocationService = Self(
    title: { TextState(L10n.Location.Alert.provideAccessToLocationService) }
  )
}

// MARK: - Dependencies

enum LocationManagerKey: DependencyKey {
  static let liveValue = LocationManager.live
  static let testValue = LocationManager.failing
}

public extension DependencyValues {
  var locationManager: LocationManager {
    get { self[LocationManagerKey.self] }
    set { self[LocationManagerKey.self] = newValue }
  }
}
