import ComposableArchitecture
import Foundation
@testable import SettingsFeature
import SharedModels
import Testing

@Suite
@MainActor
struct RideEventSettingsCoreTests {
  @Test("Set event updates binding action should update store")
  func setRideEventsEnabled() async {
    let store = TestStore(
      initialState: .init(
        settings: RideEventSettings(
          isEnabled: true,
          rideEvents: .default,
          eventDistance: .close
        )
      ),
      reducer: { RideEventsSettingsFeature() }
    )
    
    await store.send(.binding(.set(\.isEnabled, false))) {
      $0.isEnabled = false
      $0.$settings.withLock { $0.isEnabled = false }
    }
    
    await store.send(.binding(.set(\.isEnabled, true))) {
      $0.isEnabled = true
      $0.$settings.withLock { $0.isEnabled = true }
    }
  }

  @Test("Set event search radius updates binding action should update store")
  func setRideEventsRadius() async {
    let store = TestStore(
      initialState: .init(
        settings: RideEventSettings(
          isEnabled: true,
          rideEvents: .default,
          eventDistance: .close
        )
      ),
      reducer: { RideEventsSettingsFeature() },
      withDependencies: {
        $0.feedbackGenerator.selectionChanged = {}
      }
    )
    
    await store.send(.binding(.set(\.eventSearchRadius, .near))) {
      $0.eventSearchRadius = .near
    }
  }
}
