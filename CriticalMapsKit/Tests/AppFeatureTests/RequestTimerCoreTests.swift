import AppFeature
import ComposableArchitecture
import XCTest

@MainActor
final class RequestTimerCoreTests: XCTestCase {
  func test_startTimerAction_shouldSendTickedEffect() async {
    let testScheduler = DispatchQueue.test

    let store = TestStore(
      initialState: RequestTimer.State(),
      reducer: RequestTimer(timerInterval: 1)
    )
    store.dependencies.mainQueue = testScheduler.eraseToAnyScheduler()

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
