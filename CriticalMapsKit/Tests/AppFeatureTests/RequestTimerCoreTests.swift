//
//  File.swift
//  
//
//  Created by Malte on 27.06.21.
//

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
    
    store.assert(
      .send(.startTimer),
      .do { self.testScheduler.advance(by: 1) },
      .receive(.timerTicked),
      .do { self.testScheduler.advance(by: 1) },
      .receive(.timerTicked),
      .send(.stopTimer)
    )
  }
}
