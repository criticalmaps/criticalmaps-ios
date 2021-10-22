import TestHelper
import XCTest
import SettingsFeature
import SharedModels

class RideEventSettingsViewSnapshotTests: XCTestCase {
  func test_rideEventSettingsView_light() {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: RideEventSettings(
          isEnabled: true,
          typeSettings: .all,
          radiusSettings: 5
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
          radiusSettings: 5
        ),
        reducer: rideeventSettingsReducer,
        environment: RideEventSettingsEnvironment()
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
