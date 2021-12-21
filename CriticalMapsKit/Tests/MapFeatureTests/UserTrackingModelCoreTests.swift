//
//  File.swift
//  File
//
//  Created by Malte on 07.08.21.
//

import Combine
import ComposableArchitecture
@testable import MapFeature
import SharedModels
import XCTest

class UserTrackingModeCoreTests: XCTestCase {

  func test_nextTrackingMode() {
    let store = TestStore(
      initialState: UserTrackingState(userTrackingMode: .none),
      reducer: userTrackingReducer,
      environment: UserTrackingEnvironment()
    )
    
    store.assert(
      .send(.nextTrackingMode) {
        $0.mode = .follow
      },
      .send(.nextTrackingMode) {
        $0.mode = .followWithHeading
      },
      .send(.nextTrackingMode) {
        $0.mode = .none
      }
    )
  }
}
