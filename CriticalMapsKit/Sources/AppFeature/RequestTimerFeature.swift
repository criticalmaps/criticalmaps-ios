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
    public init(isTimerActive: Bool = false, cycleStartTime: Date? = nil) {
      self.isTimerActive = isTimerActive
      self.cycleStartTime = cycleStartTime
    }

    public var isTimerActive = false
    /// Timestamp when the current 60s cycle started - used by View for countdown
    public var cycleStartTime: Date?
  }

  // MARK: Action

  public enum Action: Equatable {
    case startTimer
    case halfwayPoint
    case fullCycle
  }

  @Dependency(\.continuousClock) var clock
  @Dependency(\.date.now) var now

  enum CancelID { case timer }

  /// Reducer responsible for the poll timer handling.
  /// Fires specific actions at 30s (halfwayPoint) and 60s (fullCycle) intervals.
  /// Visual countdown is handled in the View layer to avoid unnecessary reducer calls.
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .halfwayPoint, .fullCycle:
      // Reset cycle start time for the next cycle
      if action == .fullCycle {
        state.cycleStartTime = now
      }
      return .none

    case .startTimer:
      state.isTimerActive = true
      state.cycleStartTime = now

      return .run { send in
        while true {
          // Sleep for 30 seconds
          try await clock.sleep(for: .seconds(30))
          await send(.halfwayPoint)

          // Sleep for another 30 seconds
          try await clock.sleep(for: .seconds(30))
          await send(.fullCycle)
        }
      }
      .cancellable(id: CancelID.timer, cancelInFlight: true)
    }
  }
}
