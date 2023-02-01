import AppFeature
import ComposableArchitecture
import XCTest

@MainActor
final class RequestTimerCoreTests: XCTestCase {
  func test_startTimerAction_shouldSendTickedEffect() async {
    let testRunLoop = RunLoop.test

    let store = TestStore(
      initialState: RequestTimer.State(),
      reducer: RequestTimer(timerInterval: 1)
    )
    store.dependencies.mainRunLoop = testRunLoop.eraseToAnyScheduler()

    let task = await store.send(.startTimer) {
      $0.isTimerActive = true
    }
    await testRunLoop.advance(by: 1)
    await store.receive(.timerTicked)
    await testRunLoop.advance(by: 1)
    await store.receive(.timerTicked)

    await task.cancel()
  }
}
