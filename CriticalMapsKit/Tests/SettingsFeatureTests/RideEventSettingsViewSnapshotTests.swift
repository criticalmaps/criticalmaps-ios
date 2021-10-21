import TestHelper
import XCTest
import SettingsFeature

class RideEventSettingsViewSnapshotTests: XCTestCase {
  func test_rideEventSettingsView_light() {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: .init(),
        reducer: settingsReducer,
        environment: .init(
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none },
          fileClient: .noop,
          backgroundQueue: .failing,
          mainQueue: .failing)
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  func test_rideEventSettingsView_disabled() {
    let settingsView = RideEventSettingsView(
      store: .init(
        initialState: .init(
          userSettings: .init(
            appearanceSettings: .init(),
            enableObservationMode: true,
            rideEventSettings: .init(
              isEnabled: false,
              typeSettings: .all,
              radiusSettings: 5
            )
          )
        ),
        reducer: settingsReducer,
        environment: .init(
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none },
          fileClient: .noop,
          backgroundQueue: .failing,
          mainQueue: .failing)
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
