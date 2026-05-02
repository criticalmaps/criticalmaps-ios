import Foundation
import SettingsFeature
import SharedModels
import TestHelper
import Testing

@MainActor
@Suite("RideEventSettings 📸 Tests", .tags(.snapshot))
struct RideEventSettingsViewSnapshotTests {
  @Test
  func `ride event settings view light`() throws {
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
  func `ride event settings view disabled`() throws {
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
