import SettingsFeature
import SharedModels
import TestHelper
import XCTest

final class RideEventSettingsViewSnapshotTests: XCTestCase {
  func test_rideEventSettingsView_light() {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: .init(
          settings: RideEventSettings(
            isEnabled: true,
            typeSettings: .all(),
            eventDistance: .close
          )
        ),
        reducer: { RideEventsSettingsFeature() }
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  func test_rideEventSettingsView_disabled() {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: .init(
          settings: RideEventSettings(
            isEnabled: true,
            typeSettings: .all(),
            eventDistance: .close
          )
        ),
        reducer: { RideEventsSettingsFeature() }
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
