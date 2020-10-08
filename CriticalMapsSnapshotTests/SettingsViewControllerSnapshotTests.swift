//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class SettingsViewControllerSnapshotTests: XCTestCase {
    struct ObservationModePreferenceMock: ObservationModePreference {
        var observationMode: Bool = false
    }

    private let size = CGSize(width: 320, height: 1200)

    func testGeneralAppearance() {
        // Given
        let viewController = SettingsViewController(
            themeController: MockThemeController.shared,
            dataStore: MockDataStore(),
            idProvider: MockIDProvider(),
            observationModePreferenceStore: ObservationModePreferenceStore(store: ObservationModePreferenceMock())
        )
        let navigationController = UINavigationController(rootViewController: viewController)

        // Then
        assertViewSnapshot(
            matching: navigationController.view,
            with: size,
            precision: 0.99
        )
    }
}