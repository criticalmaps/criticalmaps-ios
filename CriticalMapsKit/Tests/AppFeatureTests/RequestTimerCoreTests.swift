@testable import AppFeature
import ComposableArchitecture
import XCTest

@MainActor
final class RequestTimerCoreTests: XCTestCase {
  let testScheduler = DispatchQueue.test

  func test_startTimerAction_shouldSendTickedEffect() async {
    let store = TestStore(
      initialState: RequestTimerState(),
      reducer: requestTimerReducer,
      environment: RequestTimerEnvironment(
        timerInterval: 1,
        mainQueue: testScheduler.eraseToAnyScheduler()
      )
    )

    let task = await store.send(.startTimer) {
      $0.isTimerActive = true
    }
    await testScheduler.advance(by: 1)
    await store.receive(.timerTicked)
    await testScheduler.advance(by: 1)
    await store.receive(.timerTicked)
    
    await task.cancel()
  }
}
