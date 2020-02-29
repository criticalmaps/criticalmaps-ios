//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class SettingsViewControllerSnapshotTests: XCTestCase {
    func testGeneralAppearance() {
        // Given
        let viewController = SettingsViewController(
            themeController: MockThemeController.shared,
            dataStore: MockDataStore(),
            idProvider: MockIDProvider()
        )
        let navigationController = UINavigationController(rootViewController: viewController)

        // Then
        assertViewSnapshot(matching: navigationController.view)
    }
}
