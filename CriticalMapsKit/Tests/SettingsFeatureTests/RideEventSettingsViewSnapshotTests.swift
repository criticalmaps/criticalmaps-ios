import SettingsFeature
import SharedModels
import TestHelper
import XCTest

@MainActor
final class RideEventSettingsViewSnapshotTests: XCTestCase {
  func test_rideEventSettingsView_light() throws {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: .init(
          settings: RideEventSettings(
            isEnabled: true,
            rideEvents: .default,
            eventDistance: .close
          )
        ),
        reducer: { RideEventsSettingsFeature() }
      )
    )
    
    try assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  func test_rideEventSettingsView_disabled() throws {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: .init(
          settings: RideEventSettings(
            isEnabled: true,
            rideEvents: .default,
            eventDistance: .close
          )
        ),
        reducer: { RideEventsSettingsFeature() }
      )
    )
    
    try assertScreenSnapshot(settingsView, sloppy: true)
  }
}
