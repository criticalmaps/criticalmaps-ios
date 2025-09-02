import ComposableArchitecture
import FeedbackGeneratorClient
import Foundation
import Helpers
import SharedModels

@Reducer
public struct RideEventsSettingsFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared(.rideEventSettings) var settings
    
    public var isEnabled: Bool
    public var eventSearchRadius: EventDistance
    public var rideEventTypes: IdentifiedArrayOf<RideEventType.State>
    
    public init(
      isEnabled: Bool,
      eventDistance: EventDistance = .near,
      rideEventTypes: [RideEventType.State] = []
    ) {
      self.isEnabled = isEnabled
      eventSearchRadius = eventDistance
      self.rideEventTypes = .init(uncheckedUniqueElements: rideEventTypes)
    }
  }

  @CasePathable
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case rideEventType(IdentifiedActionOf<RideEventType>)
  }
  
  // MARK: Reducer
  
  @Dependency(\.feedbackGenerator) private var feedbackGenerator

  public var body: some ReducerOf<Self> {
    BindingReducer()
      .onChange(of: \.isEnabled) { _, newValue in
        Reduce { state, _ in
          state.$settings.withLock { $0.isEnabled = newValue }
          return .none
        }
      }
      .onChange(of: \.eventSearchRadius) { _, newValue in
        Reduce { state, _ in
          state.$settings.withLock { $0.eventDistance = newValue }
          return .run { _ in
            await feedbackGenerator.selectionChanged()
          }
        }
      }
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .rideEventType:
        state.$settings.withLock {
          $0.rideEvents = state.rideEventTypes.map {
            RideEvent(rideType: $0.rideType, isEnabled: $0.isEnabled)
          }
        }
        return .run { _ in
          await feedbackGenerator.selectionChanged()
        }
      }
    }
    .forEach(\.rideEventTypes, action: \.rideEventType) {
      RideEventType()
    }
  }
}

public extension RideEventsSettingsFeature.State {
  init(settings: RideEventSettings) {
    self.init(
      isEnabled: settings.isEnabled,
      eventDistance: settings.eventDistance,
      rideEventTypes: settings.rideEvents
        .map { .init(rideType: $0.rideType, isEnabled: $0.isEnabled) }
        .sorted(by: \.rideType.title)
    )
  }
}
