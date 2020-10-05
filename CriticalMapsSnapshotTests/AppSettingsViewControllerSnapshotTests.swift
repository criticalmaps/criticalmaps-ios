//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest
class AppSettingsViewControllerSnapshotTests: XCTestCase {
    struct ObservationModePreferenceMock: ObservationModePreference {
        var observationMode: Bool = false
    }

    private let size = CGSize(width: 320, height: 1200)

    func testGeneralAppearance() {
        // Given
        let viewController = AppSettingsViewController(
            controllerTitle: L10n.settingsTitle,
            sections: SettingsSection.appSettings,
            themeController: MockThemeController.shared,
            dataStore: MockDataStore(),
            idProvider: MockIDProvider(),
            observationModePreferenceStore: ObservationModePreferenceStore(store: ObservationModePreferenceMock()),
            rideEventSettings: RideEventSettingsStoreMock(
                rideEventSettings: RideEventSettings(
                    isEnabled: true,
                    typeSettings: .all,
                    radiusSettings: RideEventSettings.RideEventRadius(radius: 20, isEnabled: true)
                )
            )
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

struct RideEventSettingsStoreMock: RideEventSettingsStore {
    var rideEventSettings: RideEventSettings
}
