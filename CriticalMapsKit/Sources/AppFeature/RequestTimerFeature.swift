import ApiClient
import ComposableArchitecture
import Foundation

@Reducer
public struct RequestTimer: Sendable {
  public init() {}

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
  @Dependency(\.serverConfiguration) var serverConfiguration

  enum CancelID { case timer }

  /// Reducer responsible for the poll timer handling.
  /// Fires specific actions at 30s (halfwayPoint) and 60s (fullCycle) intervals.
  /// Visual countdown is handled in the View layer to avoid unnecessary reducer calls.
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
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

        // Split the poll cycle into two halves: post location at the halfway
        // point, fetch riders at the full cycle. Production = 60s (30s + 30s);
        // a dev build can shorten this via `serverConfiguration`.
        let fullCycle = serverConfiguration.pollIntervalSeconds
        let firstHalf = fullCycle / 2
        let secondHalf = fullCycle - firstHalf

        return .run { send in
          while true {
            try await clock.sleep(for: .seconds(firstHalf))
            await send(.halfwayPoint)

            try await clock.sleep(for: .seconds(secondHalf))
            await send(.fullCycle)
          }
        }
        .cancellable(id: CancelID.timer, cancelInFlight: true)
      }
    }
  }
}
