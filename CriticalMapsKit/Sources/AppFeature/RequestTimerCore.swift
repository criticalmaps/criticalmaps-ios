import ComposableArchitecture
import Foundation

public struct RequestTimer: ReducerProtocol {
  public init(timerInterval: Double = 12.0) {
    self.timerInterval = timerInterval
  }
  
  @Dependency(\.mainQueue) public var mainQueue
  let timerInterval: Double
  
  var interval: DispatchQueue.SchedulerTimeType.Stride {
    DispatchQueue.SchedulerTimeType.Stride(floatLiteral: timerInterval)
  }

  // MARK: State

  public struct State: Equatable {
    public init(isTimerActive: Bool = false) {
      self.isTimerActive = isTimerActive
    }
    
    var isTimerActive = false
  }
  
  // MARK: Action
  
  public enum Action: Equatable {
    case timerTicked
    case startTimer
  }
  
  /// Reducer responsible for the poll timer handling.
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
    case .timerTicked:
      return .none

    case .startTimer:
      state.isTimerActive = true
      return .run { [isTimerActive = state.isTimerActive] send in
        guard isTimerActive else { return }
        for await _ in mainQueue.timer(interval: interval) {
          await send(.timerTicked)
        }
      }
      .cancellable(id: TimerId.self, cancelInFlight: true)
    }
  }
}

struct TimerId: Hashable {}
