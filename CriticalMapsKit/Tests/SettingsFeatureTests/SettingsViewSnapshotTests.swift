import SettingsFeature
import TestHelper
import XCTest

final class SettingsViewSnapshotTests: XCTestCase {
  func test_settingsView_light() {
    let settingsView = SettingsView(
      store: .init(
        initialState: .init(userSettings: .init()),
        reducer: SettingsFeature()
      )
    )

    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
