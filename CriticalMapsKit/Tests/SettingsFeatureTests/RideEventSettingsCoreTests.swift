import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

final class RideEventSettingsCoreTests: XCTestCase {
  
  @MainActor
  func test_setRideEventsEnabled() async {
    let store = TestStore(
      initialState: .init(
        settings: RideEventSettings(
          isEnabled: true,
          typeSettings: .all(),
          eventDistance: .close
        )
      ),
      reducer: { RideEventsSettingsFeature() }
    )
    
    await store.send(.set(\.$isEnabled, false)) {
      $0.isEnabled = false
    }
    
    await store.send(.set(\.$isEnabled, true)) {
      $0.isEnabled = true
    }
  }
  
  @MainActor
  func test_setRideEventsTypeEnabled() async {
    let store = TestStore(
      initialState: RideEventType.State(
        rideType: .criticalMass,
        isEnabled: false
      ),
      reducer: {
        RideEventType()
      }
    )
    
    await store.send(.set(\.$isEnabled, true)) {
      $0.isEnabled = true
    }
  }
  
  @MainActor
  func test_setRideEventsRadius() async {
    let store = TestStore(
      initialState: .init(
        settings: RideEventSettings(
          isEnabled: true,
          typeSettings: .all(),
          eventDistance: .close
        )
      ),
      reducer: { RideEventsSettingsFeature() },
      withDependencies: {
        $0.feedbackGenerator.selectionChanged = {}
      }
    )
    
    await store.send(.set(\.$eventSearchRadius, .near)) {
      $0.eventSearchRadius = .near
    }
  }
}
