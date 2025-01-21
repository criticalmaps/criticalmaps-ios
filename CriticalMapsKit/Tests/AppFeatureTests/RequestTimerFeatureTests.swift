import AppFeature
import ComposableArchitecture
import Foundation
import Testing

@MainActor
struct RequestTimerCoreTests {
  @Test
  func startTimerAction_shouldSendTickedEffect() async {
    let testRunLoop = RunLoop.test

    let store = TestStore(
      initialState: RequestTimer.State(),
      reducer: { RequestTimer(timerInterval: 1) }
    )
    store.dependencies.mainRunLoop = testRunLoop.eraseToAnyScheduler()

    let task = await store.send(.startTimer) {
      $0.isTimerActive = true
    }
    await testRunLoop.advance(by: 1)
    await store.receive(.timerTicked) {
      $0.secondsElapsed = 1
    }
    await testRunLoop.advance(by: 1)
    await store.receive(.timerTicked) {
      $0.secondsElapsed = 2
    }    
    await task.cancel()
  }
}
