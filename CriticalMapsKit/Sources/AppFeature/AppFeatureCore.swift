//
//  File.swift
//
//
//  Created by Malte on 16.06.21.
//

import ApiClient
import ComposableArchitecture
import ComposableCoreLocation
import Logger
import IDProvider
import SharedModels
import MapFeature

// MARK: State
public struct AppState: Equatable {
  public init(locationsAndChatMessages: LocationAndChatMessages) {
    self.locationsAndChatMessages = locationsAndChatMessages
  }
  
  var locationsAndChatMessages: LocationAndChatMessages
  
  var mapFeatureState: MapFeatureState = MapFeatureState(riders: [])
}

// MARK: Actions
public enum AppAction: Equatable {
  case onAppear
  case fetchData
  case fetchDataResponse(Result<LocationAndChatMessages, LocationsAndChatDataService.Failure>)
  case timerTicked
  case startTimer
  
  case map(MapFeatureAction)
}

// MARK: Environment
public struct AppEnvironment {
  public init(
    service: LocationsAndChatDataService,
    idProvider: IDProvider,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.service = service
    self.idProvider = idProvider
    self.mainQueue = mainQueue
  }
  
  let service: LocationsAndChatDataService
  let idProvider: IDProvider
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let timerInterval = 2.0
}

struct TimerId: Hashable {}

// MARK: Reducer
public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  mapFeatureReducer.pullback(
    state: \.mapFeatureState,
    action: /AppAction.map,
    environment: { _ in MapFeatureEnvironment(locationManager: .live) }
  ),
  Reducer { state, action, environment in
    switch action {
    case .onAppear:
      return .merge(
        Effect(value: AppAction.map(.onAppear)),
        Effect(value: .startTimer),
        Effect(value: AppAction.fetchData)
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
      state.locationsAndChatMessages = response
      state.mapFeatureState.riders = response.riders
      return .none
      
    case let .fetchDataResponse(.failure(error)):
      Logger.logger.info("FetchData failed: \(error)")
      return .none
      
    case .timerTicked:
      return Effect(value: .fetchData)
      
    case .startTimer:
      return Effect.timer(
          id: TimerId(),
          every: .seconds(environment.timerInterval),
          on: environment.mainQueue
        )
        .map { _ in AppAction.timerTicked }
      
    case let .map(mapFeatureAction):
      switch mapFeatureAction {
      case .updateRiderCoordinates:
        print(state.mapFeatureState.riders)
      default:
        break
      }
      return .none
    }
  }
)

fileprivate typealias S = AppState
fileprivate typealias A = AppAction

extension SharedModels.Location {
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
