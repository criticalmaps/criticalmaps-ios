import ComposableArchitecture
import FeedbackGeneratorClient
import Foundation
import Helpers
import SharedModels

public struct RideEventsSettingsFeature: Reducer {
  public init() {}
  
  @Dependency(\.feedbackGenerator) private var feedbackGenerator
  
  public struct State: Equatable, Sendable {
    @BindingState public var isEnabled: Bool
    @BindingState public var eventSearchRadius: EventDistance
    public var rideEventTypes: IdentifiedArrayOf<RideEventType.State> = []
    
    public init(
      isEnabled: Bool,
      eventDistance: EventDistance,
      rideEventTypes: [RideEventType.State]
    ) {
      self.isEnabled = isEnabled
      self.eventSearchRadius = eventDistance
      self.rideEventTypes = .init(uncheckedUniqueElements: rideEventTypes)
    }
  }

  // MARK: Actions

  @CasePathable
  public enum Action: BindableAction, Equatable, Sendable {
    case binding(BindingAction<State>)
    case rideEventType(IdentifiedActionOf<RideEventType>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { _, action in
      switch action {
      case .binding(\.$eventSearchRadius):
        return .run { _ in
          await feedbackGenerator.selectionChanged()
        }
        
      case .rideEventType:
        return .run { _ in
          await feedbackGenerator.selectionChanged()
        }
        
      case .binding:
        return .none
      }
    }
    .forEach(\.rideEventTypes, action: \.rideEventType) {
      RideEventType()
    }
  }
}

extension RideEventsSettingsFeature.State {
  public init(settings: RideEventSettings) {
    self.init(
      isEnabled: settings.isEnabled,
      eventDistance: settings.eventDistance,
      rideEventTypes: settings.typeSettings
        .map { RideEventType.State(rideType: $0.key, isEnabled: $0.value) }
        .sorted(by: \.rideType.title)
    )
  }
}
