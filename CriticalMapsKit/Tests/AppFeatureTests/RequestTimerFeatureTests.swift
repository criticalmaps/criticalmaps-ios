import AppFeature
import ComposableArchitecture
import Foundation
import Testing

@MainActor
struct RequestTimerCoreTests {
  @Test("Timer fires halfwayPoint at 30s and fullCycle at 60s")
  func startTimer_firesActionsAtCorrectIntervals() async {
    let testClock = TestClock()
    let testDate = Date(timeIntervalSince1970: 1000)

    let store = TestStore(
      initialState: RequestTimer.State(),
      reducer: { RequestTimer() }
    ) {
      $0.continuousClock = testClock
      $0.date.now = testDate
    }

    // Start the timer
    let task = await store.send(.startTimer) {
      $0.isTimerActive = true
      $0.cycleStartTime = testDate
    }

    // Advance 30 seconds - should fire halfwayPoint
    await testClock.advance(by: .seconds(30))
    await store.receive(.halfwayPoint)

    // Advance another 30 seconds - should fire fullCycle
    await testClock.advance(by: .seconds(30))
    await store.receive(.fullCycle)

    // Verify it continues cycling
    await testClock.advance(by: .seconds(30))
    await store.receive(.halfwayPoint)

    await task.cancel()
  }

  @Test("Timer can be cancelled mid-cycle")
  func startTimer_canBeCancelled() async {
    let testClock = TestClock()
    let testDate = Date(timeIntervalSince1970: 1000)

    let store = TestStore(
      initialState: RequestTimer.State(),
      reducer: { RequestTimer() }
    ) {
      $0.continuousClock = testClock
      $0.date.now = testDate
    }

    let task = await store.send(.startTimer) {
      $0.isTimerActive = true
      $0.cycleStartTime = testDate
    }

    // Advance partway through cycle
    await testClock.advance(by: .seconds(15))

    await task.cancel()

    // Advancing further should not trigger actions
    await testClock.advance(by: .seconds(100))
  }

  @Test("Multiple timer starts cancel previous timer")
  func startTimer_cancelsPreviousTimer() async {
    let testClock = TestClock()
    let testDate = Date(timeIntervalSince1970: 1000)

    let store = TestStore(
      initialState: RequestTimer.State(),
      reducer: { RequestTimer() }
    ) {
      $0.continuousClock = testClock
      $0.date.now = testDate
    }
    store.exhaustivity = .off

    // Start first timer
    await store.send(.startTimer) {
      $0.isTimerActive = true
      $0.cycleStartTime = testDate
    }

    // Advance partway
    await testClock.advance(by: .seconds(15))

    // Start second timer - should cancel first
    await store.send(.startTimer) {
      $0.cycleStartTime = testDate
    }

    // First timer's 30s mark should not fire
    await testClock.advance(by: .seconds(15))

    // Second timer's 30s mark should fire
    await testClock.advance(by: .seconds(15))
    await store.receive(.halfwayPoint)
  }
}
