import SettingsFeature
import TestHelper
import XCTest

class SettingsViewSnapshotTests: XCTestCase {
  func test_settingsView_light() {
    let settingsView = SettingsView(
      store: .init(
        initialState: .init(),
        reducer: settingsReducer,
        environment: SettingsEnvironment(
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none },
          fileClient: .noop,
          backgroundQueue: .immediate,
          mainQueue: .immediate
        )
      )
    )

    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
