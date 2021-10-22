import ComposableArchitecture
import Helpers
import SharedModels

public enum RideEventSettingsActions: Equatable {
  case setRideEventsEnabled(Bool)
  case setRideEventTypeEnabled(RideEventSettings.RideEventTypeSetting)
  case setRideEventRadius(Int)
}

public struct RideEventSettingsEnvironment {
  public init() {}
}


public let rideeventSettingsReducer = Reducer<RideEventSettings, RideEventSettingsActions, RideEventSettingsEnvironment> { state, action, _ in
  switch action {
  case let .setRideEventsEnabled(value):
    state.isEnabled = value
    return .none
    
  case let .setRideEventTypeEnabled(type):
    guard let index = state.typeSettings.firstIndex(where: { $0.type == type.type })
    else { return .none }
    state.typeSettings[index].isEnabled = type.isEnabled
    return .none
    
  case let .setRideEventRadius(radius):
    state.radiusSettings = radius
    return .none
  }
}
