import ComposableArchitecture

public struct RequestTimerState: Equatable {
  public init(isTimerActive: Bool = false) {
    self.isTimerActive = isTimerActive
  }
  
  var isTimerActive = false
}

public enum RequestTimerAction: Equatable {
  case timerTicked
  case startTimer
}

public struct RequestTimerEnvironment {
  let timerInterval: Double
  let mainQueue: AnySchedulerOf<DispatchQueue>

  var interval: DispatchQueue.SchedulerTimeType.Stride {
    DispatchQueue.SchedulerTimeType.Stride(floatLiteral: timerInterval)
  }
  
  public init(timerInterval: Double = 12.0, mainQueue: AnySchedulerOf<DispatchQueue>) {
    self.timerInterval = timerInterval
    self.mainQueue = mainQueue
  }
}

/// Reducer responsible for the poll timer handling.
public let requestTimerReducer = Reducer<RequestTimerState, RequestTimerAction, RequestTimerEnvironment> { state, action, environment in
  struct TimerId: Hashable {}

  switch action {
  case .timerTicked:
    return .none

  case .startTimer:
    state.isTimerActive = true
    return .run { [isTimerActive = state.isTimerActive] send in
      guard isTimerActive else { return }
      for await _ in environment.mainQueue.timer(interval: environment.interval) {
        await send(.timerTicked)
      }
    }
    .cancellable(id: TimerId.self, cancelInFlight: true)
  }
}
