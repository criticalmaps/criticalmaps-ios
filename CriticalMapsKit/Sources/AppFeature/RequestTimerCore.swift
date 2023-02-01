import ComposableArchitecture
import Foundation

public struct RequestTimer: ReducerProtocol {
  public init(timerInterval: Int = 12) {
    self.timerInterval = .seconds(timerInterval)
  }

  @Dependency(\.mainRunLoop) var mainRunLoop
  let timerInterval: RunLoop.SchedulerTimeType.Stride

  // MARK: State

  public struct State: Equatable {
    public init(isTimerActive: Bool = false) {
      self.isTimerActive = isTimerActive
    }

    public var isTimerActive = false
  }

  // MARK: Action

  public enum Action: Equatable {
    case timerTicked
    case startTimer
  }

  /// Reducer responsible for the poll timer handling.
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .timerTicked:
      return .none

    case .startTimer:
      state.isTimerActive = true
      return .run { [isTimerActive = state.isTimerActive] send in
        guard isTimerActive else { return }
        for await _ in mainRunLoop.timer(interval: timerInterval) {
          await send(.timerTicked)
        }
      }
      .cancellable(id: TimerId.self, cancelInFlight: true)
    }
  }
}

private struct TimerId: Hashable {}
