import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

final class RideEventSettingsCoreTests: XCTestCase {
  func test_setRideEventsEnabled() {
    let store = TestStore(
      initialState: .init(
        settings: RideEventSettings(
          isEnabled: true,
          typeSettings: .all(),
          eventDistance: .close
        )
      ),
      reducer: RideEventsSettingsFeature()
    )
    
    store.send(.set(\.$isEnabled, false)) {
      $0.isEnabled = false
    }
    
    store.send(.set(\.$isEnabled, true)) {
      $0.isEnabled = true
    }
  }
  
  func test_setRideEventsTypeEnabled() {
    let store = TestStore(
      initialState: RideEventType.State(rideType: .criticalMass, isEnabled: false),
      reducer: RideEventType()
    )
    
    store.send(.set(\.$isEnabled, true)) {
      $0.isEnabled = true
    }
  }
  
  func test_setRideEventsRadius() {
    let store = TestStore(
      initialState: .init(
        settings: RideEventSettings(
          isEnabled: true,
          typeSettings: .all(),
          eventDistance: .close
        )
      ),
      reducer: RideEventsSettingsFeature()
    )
    
    store.send(.set(\.$eventSearchRadius, .near)) {
      $0.eventSearchRadius = .near
    }
  }
}
