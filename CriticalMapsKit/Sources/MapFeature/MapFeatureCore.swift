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

public struct MapFeatureState: Equatable {
  public init(
    alert: AlertState<MapFeatureAction>? = nil,
    isRequestingCurrentLocation: Bool = false,
    region: CoordinateRegion? = nil,
    location: ComposableCoreLocation.Location? = nil,
    riders: [Rider]
  ) {
    self.alert = alert
    self.isRequestingCurrentLocation = isRequestingCurrentLocation
    self.region = region
    self.location = location
    self.riders = riders
  }
  
  public var alert: AlertState<MapFeatureAction>?
  public var isRequestingCurrentLocation: Bool
  public var region: CoordinateRegion?
  public var location: ComposableCoreLocation.Location?
  public var riders: [Rider]
}

public enum MapFeatureAction: Equatable {
  case locationManager(LocationManager.Action)
  
  case onAppear
  case locationRequested
  case updateRiderCoordinates([Rider])
  case updateRegion(CoordinateRegion?)
}

public struct MapFeatureEnvironment {
  public init(locationManager: LocationManager) {
    self.locationManager = locationManager
  }
  
  let locationManager: LocationManager
}

private struct LocationManagerId: Hashable {}

public let mapFeatureReducer = Reducer<MapFeatureState, MapFeatureAction, MapFeatureEnvironment> { state, action, environment in
  switch action {
  case .locationManager:
    return .none
    
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
    
  case let .updateRiderCoordinates(riderCoordinates):
    state.riders = riderCoordinates
    return .none
    
  case .updateRegion:
    return .none
  }
}
.combined(
  with:
    locationManagerReducer
    .pullback(
      state: \.self,
      action: /MapFeatureAction.locationManager,
      environment: { $0 }
    )
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
    state.region = CoordinateRegion(
      center: location.coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    return .none
    
  default:
    return .none
  }
}

extension LocationManager {
  func setup(id: AnyHashable) -> Effect<Never, Never> {
    set(
      id: id,
      activityType: .otherNavigation,
      desiredAccuracy: kCLLocationAccuracyBestForNavigation,
      distanceFilter: nil,
      headingFilter: nil,
      headingOrientation: nil,
      pausesLocationUpdatesAutomatically: false,
      showsBackgroundLocationIndicator: true
    )
  }
}

extension AlertState where Action == MapFeatureAction {
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
