import ComposableArchitecture
import Helpers
import SharedModels

// MARK: Actions

public enum RideEventSettingsActions: Equatable {
  case setRideEventsEnabled(Bool)
  case setRideEventTypeEnabled(RideEventSettings.RideEventTypeSetting)
  case setRideEventRadius(EventDistance)
}

// MARK: Environment

public struct RideEventSettingsEnvironment {
  public init() {}
}

public typealias EventReducer = Reducer<RideEventSettings, RideEventSettingsActions, RideEventSettingsEnvironment>
/// Reducer handling next ride event settings actions
public let rideeventSettingsReducer = EventReducer { state, action, _ in
  switch action {
  case let .setRideEventsEnabled(value):
    state.isEnabled = value
    return .none

  case let .setRideEventTypeEnabled(type):
    guard let index = state.typeSettings.firstIndex(where: { $0.type == type.type }) else {
      return .none
    }
    state.typeSettings[index].isEnabled = type.isEnabled
    return .none

  case let .setRideEventRadius(distance):
    state.eventDistance = distance
    return .none
  }
}
