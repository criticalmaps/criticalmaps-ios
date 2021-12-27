import SettingsFeature
import SharedModels
import TestHelper
import XCTest

class RideEventSettingsViewSnapshotTests: XCTestCase {
  func test_rideEventSettingsView_light() {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: RideEventSettings(
          isEnabled: true,
          typeSettings: .all,
          eventDistance: .close
        ),
        reducer: rideeventSettingsReducer,
        environment: RideEventSettingsEnvironment()
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  func test_rideEventSettingsView_disabled() {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: RideEventSettings(
          isEnabled: false,
          typeSettings: .all,
          eventDistance: .close
        ),
        reducer: rideeventSettingsReducer,
        environment: RideEventSettingsEnvironment()
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
