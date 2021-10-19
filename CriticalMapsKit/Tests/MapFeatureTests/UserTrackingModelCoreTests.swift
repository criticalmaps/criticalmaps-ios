//
//  File.swift
//  File
//
//  Created by Malte on 07.08.21.
//

@testable import MapFeature
import Combine
import ComposableArchitecture
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
        $0.userTrackingMode = .follow
      },
      .send(.nextTrackingMode){
        $0.userTrackingMode = .followWithHeading
      },
      .send(.nextTrackingMode){
        $0.userTrackingMode = .none
      }
    )
  }
}