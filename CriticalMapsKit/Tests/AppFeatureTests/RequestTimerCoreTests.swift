@testable import AppFeature
import ComposableArchitecture
import XCTest

class RequestTimerCoreTests: XCTestCase {
  let testScheduler = DispatchQueue.test
  
  func test_startTimerAction_shouldSendTickedEffect() {
    let store = TestStore(
      initialState: RequestTimerState(),
      reducer: requestTimerReducer,
      environment: RequestTimerEnvironment(
        timerInterval: 1,
        mainQueue: testScheduler.eraseToAnyScheduler()
      )
    )
    
    store.send(.startTimer)
    self.testScheduler.advance(by: 1)
    store.receive(.timerTicked)
    self.testScheduler.advance(by: 1)
    store.receive(.timerTicked)
    store.send(.stopTimer)
  }
}
