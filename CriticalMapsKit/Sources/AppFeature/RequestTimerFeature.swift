import ComposableArchitecture
import Foundation

@Reducer
public struct RequestTimer {
  public init(timerInterval: Int = 60) {
    self.timerInterval = .seconds(timerInterval)
  }
  
  let timerInterval: RunLoop.SchedulerTimeType.Stride

  // MARK: State

  public struct State: Equatable {
    public init(isTimerActive: Bool = false) {
      self.isTimerActive = isTimerActive
    }

    public var isTimerActive = false
    public var secondsElapsed = 0
  }

  // MARK: Action

  public enum Action: Equatable {
    case timerTicked
    case startTimer
  }

  @Dependency(\.mainRunLoop) var mainRunLoop
  
  /// Reducer responsible for the poll timer handling.
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .timerTicked:
      state.secondsElapsed += 1
      return .none

    case .startTimer:
      state.isTimerActive = true
      return .run { [isTimerActive = state.isTimerActive] send in
        guard isTimerActive else { return }
        for await _ in mainRunLoop.timer(interval: .seconds(1)) {
          await send(.timerTicked, animation: .snappy)
        }
      }
      .cancellable(id: Timer.cancel, cancelInFlight: true)
    }
  }
}

enum Timer { case cancel }
