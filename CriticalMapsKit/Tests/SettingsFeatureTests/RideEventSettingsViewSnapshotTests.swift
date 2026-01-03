import Foundation
import SettingsFeature
import SharedModels
import TestHelper
import Testing

@MainActor
@Suite("RideEventSettings 📸 Tests", .tags(.snapshot))
struct RideEventSettingsViewSnapshotTests {
  @Test
  func rideEventSettingsView_light() throws {
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
    
    try SnapshotHelper.assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  @Test
  func rideEventSettingsView_disabled() throws {
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
    
    try SnapshotHelper.assertScreenSnapshot(settingsView, sloppy: true)
  }
}
