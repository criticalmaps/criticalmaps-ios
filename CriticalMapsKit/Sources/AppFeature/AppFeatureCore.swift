//
//  File.swift
//
//
//  Created by Malte on 16.06.21.
//

import ApiClient
import ComposableArchitecture
import ComposableCoreLocation
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
  var isChatViewPresented: Bool {
    route == .chat
  }
  var isRulesViewPresented: Bool {
    route == .rules
  }
  var isSettingsViewPresented: Bool {
    route == .settings
  }
}

public struct LocationAndChatMessagesError: Error, Equatable {}

// MARK: Actions
public enum AppAction: Equatable {
  case onAppear
  case fetchData
  case fetchDataResponse(Result<LocationAndChatMessages, LocationsAndChatDataService.Failure>)
  
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
  let locationManager: ComposableCoreLocation.LocationManager
  let infoBannerPresenter: InfoBannerPresenter
  let uiApplicationClient: UIApplicationClient
  
  public init(
    service: LocationsAndChatDataService = .live(),
    idProvider: IDProvider = .live(),
    mainQueue: AnySchedulerOf<DispatchQueue> = .main,
    locationManager: ComposableCoreLocation.LocationManager = .live,
    nextRideService: NextRideService = .live(),
    userDefaultsClient: UserDefaultsClient = .live(),
    date: @escaping () -> Date = Date.init,
    infoBannerPresenter: InfoBannerPresenter,
    uiApplicationClient: UIApplicationClient
  ) {
    self.service = service
    self.idProvider = idProvider
    self.mainQueue = mainQueue
    self.locationManager = locationManager
    self.nextRideService = nextRideService
    self.userDefaultsClient = userDefaultsClient
    self.date = date
    self.infoBannerPresenter = infoBannerPresenter
    self.uiApplicationClient = uiApplicationClient
  }
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
        infobannerController: $0.infoBannerPresenter,
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
    environment: { global in SettingsEnvironment(uiApplicationClient: global.uiApplicationClient) }
  ),
  Reducer { state, action, environment in
    switch action {
    case .onAppear:
      return .merge(
        Effect(value: .map(.onAppear)),
        Effect(value: .requestTimer(.startTimer))
      )
      
    case .fetchData:
      struct GetLocationsId: Hashable {}
      let postBody = SendLocationAndChatMessagesPostBody(
        device: environment.idProvider.id(),
        location: Location(state.mapFeatureState.location)
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
      environment.infoBannerPresenter.show(.error(message: "ServerError", action: nil))
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
        return .future { callback in
          environment.infoBannerPresenter.show(
            .criticalMass(
              message: ride.titleAndTime,
              subTitle: ride.location,
              action: { callback(.success(.map(.focusNextRide))) }
            )
          )
        }
      default:
        return .none
      }
      
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
