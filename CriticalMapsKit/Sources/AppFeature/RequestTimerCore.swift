import ComposableArchitecture

public struct RequestTimerState: Equatable {
  public init() {}
}

public enum RequestTimerAction: Equatable {
  case timerTicked
  case startTimer
  case stopTimer
}

public struct RequestTimerEnvironment {
  let timerInterval: Double
  let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(timerInterval: Double = 12.0, mainQueue: AnySchedulerOf<DispatchQueue>) {
    self.timerInterval = timerInterval
    self.mainQueue = mainQueue
  }
}

public let requestTimerReducer = Reducer<RequestTimerState, RequestTimerAction, RequestTimerEnvironment> { _, action, environment in
  struct TimerId: Hashable {}
  
  switch action {
  case .timerTicked:
    return .none
    
  case .startTimer:
    return Effect.timer(
      id: TimerId(),
      every: .seconds(environment.timerInterval),
      on: environment.mainQueue
    )
    .map { _ in .timerTicked }
    
  // needed for tests mainly
  case .stopTimer:
    return .cancel(id: TimerId())
  }
}
