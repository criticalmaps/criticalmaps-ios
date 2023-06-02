import ComposableArchitecture
import Helpers
import SharedModels

public struct RideEventsSettingsFeature: ReducerProtocol {
  public init() {}

  public typealias State = SharedModels.RideEventSettings

  // MARK: Actions

  public enum Action: Equatable {
    case setRideEventsEnabled(Bool)
    case setRideEventTypeEnabled(RideEventSettings.RideEventTypeSetting)
    case setRideEventRadius(EventDistance)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
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
      guard distance != state.eventDistance else {
        return .none
      }
      state.eventDistance = distance
      return .none
    }
  }
}
