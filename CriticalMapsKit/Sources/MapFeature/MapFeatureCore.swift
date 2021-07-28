//
//  File.swift
//  
//
//  Created by Malte on 14.06.21.
//

import ComposableCoreLocation
import Foundation
import MapKit
import SharedModels
import InfoBar

public struct MapFeatureState: Equatable {
  public var alert: AlertState<MapFeatureAction>?
  public var isRequestingCurrentLocation: Bool
  public var location: ComposableCoreLocation.Location?
  public var riders: [Rider]
  public var nextRide: Ride?
  
  public var userTrackingMode: UserTrackingState
  
  public var shouldAnimateTrackingMode = true
  
  public init(
    alert: AlertState<MapFeatureAction>? = nil,
    isRequestingCurrentLocation: Bool = false,
    location: ComposableCoreLocation.Location? = nil,
    riders: [Rider],
    userTrackingMode: UserTrackingState,
    nextRide: Ride? = nil
  ) {
    self.alert = alert
    self.isRequestingCurrentLocation = isRequestingCurrentLocation
    self.location = location
    self.riders = riders
    self.userTrackingMode = userTrackingMode
  }
}

public enum MapFeatureAction: Equatable {
  case onAppear
  case locationRequested
  case updateRiderCoordinates([Rider])
  case updateRegion(CoordinateRegion?)
  case updateUserTrackingMode(MKUserTrackingMode)
  case nextTrackingMode
  case updateShouldAnimateTrackingMode
  
  case locationManager(LocationManager.Action)
  case userTracking(UserTrackingAction)
}

public struct MapFeatureEnvironment {
  public init(locationManager: LocationManager, infobannerController: InfobarController) {
    self.locationManager = locationManager
    self.infobannerController = infobannerController
  }
  
  let locationManager: LocationManager
  let infobannerController: InfobarController
}

/// Used to identify locatioManager effects.
private struct LocationManagerId: Hashable {}

public let mapFeatureReducer = Reducer<MapFeatureState, MapFeatureAction, MapFeatureEnvironment>.combine(
  userTrackingReducer.pullback(
    state: \.userTrackingMode,
    action: /MapFeatureAction.userTracking,
    environment: { _ in UserTrackingEnvironment() }
  ),
  locationManagerReducer.pullback(
    state: \.self,
    action: /MapFeatureAction.locationManager,
    environment: { $0 }
  ),
  Reducer { state, action, environment in
    switch action {
    case .onAppear:
      return .merge(
        environment.locationManager
          .create(id: LocationManagerId())
          .map(MapFeatureAction.locationManager),
        environment.locationManager
          .setup(id: LocationManagerId())
          .fireAndForget(),
        Effect(value: MapFeatureAction.locationRequested)
      )
      
    case .locationRequested:
      guard environment.locationManager.locationServicesEnabled() else {
        state.alert = .servicesOff
        return .none
      }
      switch environment.locationManager.authorizationStatus() {
      case .notDetermined:
        state.isRequestingCurrentLocation = true
        
        return environment.locationManager
          .requestAlwaysAuthorization(id: LocationManagerId())
          .fireAndForget()
        
      case .restricted:
        state.alert = .goToSettingsAlert
        return .none
        
      case .denied:
        state.alert = .goToSettingsAlert
        return .none
        
      case .authorizedAlways, .authorizedWhenInUse:
        return environment.locationManager
          .requestLocation(id: LocationManagerId())
          .fireAndForget()
        
      @unknown default:
        return .none
      }
      
    case .nextTrackingMode:
      switch state.userTrackingMode.userTrackingMode {
      case .follow:
        return Effect(value: .updateUserTrackingMode(.followWithHeading))
      case .followWithHeading:
        return Effect(value: .updateUserTrackingMode(.none))
      case .none:
        return Effect(value: .updateUserTrackingMode(.follow))
      @unknown default:
        fatalError()
      }
    case let .updateUserTrackingMode(mode):
      state.shouldAnimateTrackingMode = mode.rawValue != state.userTrackingMode.userTrackingMode.rawValue
      state.userTrackingMode.userTrackingMode = mode
      return .none
      
    case .updateShouldAnimateTrackingMode:
      return .none
      
    case .updateRiderCoordinates:
      return .none
    case .updateRegion:
      return .none
    case .locationManager:
      return .none
    case .userTracking:
      return .none
    }
  }
)

private let locationManagerReducer = Reducer<MapFeatureState, LocationManager.Action, MapFeatureEnvironment> {
  state, action, environment in
  
  switch action {
  case .didChangeAuthorization(.authorizedAlways),
       .didChangeAuthorization(.authorizedWhenInUse):
    if state.isRequestingCurrentLocation {
      return environment.locationManager
        .requestLocation(id: LocationManagerId())
        .fireAndForget()
    }
    return .none
    
  case .didChangeAuthorization(.denied):
    if state.isRequestingCurrentLocation {
      state.alert = AlertState(
        title: TextState("Location makes this app better. Please consider giving us access.")
      )
      state.isRequestingCurrentLocation = false
    }
    return .none
    
  case let .didUpdateLocations(locations):
    state.isRequestingCurrentLocation = false
    guard let location = locations.first else { return .none }
    state.location = location
    return .none
    
  default:
    return .none
  }
}

extension LocationManager {
  /// Configures the LocationManager
  func setup(id: AnyHashable) -> Effect<Never, Never> {
    set(
      id: id,
      activityType: .otherNavigation,
      desiredAccuracy: kCLLocationAccuracyBestForNavigation,
      pausesLocationUpdatesAutomatically: false,
      showsBackgroundLocationIndicator: true
    )
  }
}

public extension AlertState where Action == MapFeatureAction {
  static let goToSettingsAlert = Self(
    title: TextState("L10n.Location.Alert.provideAccessToLocationService"),
    primaryButton: .default(TextState("Einstellungen")),
    secondaryButton: .default(TextState("OK"))
  )
  
  static let provideAuth = Self(title: TextState("L10n.Location.Alert.provideAuth"))
  static let servicesOff = Self(title: TextState("L10n.Location.Alert.serviceIsOff"))
  static let reverseGeoCodingFailed = Self(title: TextState("Reverse geo coding failed"))
  static let provideAccessToLocationService = Self(
    title: TextState("L10n.Location.Alert.provideAccessToLocationService")
  )
}
