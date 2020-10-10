//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class EventSettingsViewControllerSnapshotTests: XCTestCase {
    struct ObservationModePreferenceMock: ObservationModePreference {
        var observationMode: Bool = false
    }

    private let size = CGSize(width: 320, height: 1200)

    func testGeneralAppearanceWhenNotificationsAreEnabled() {
        // Given
        let viewController = EventSettingsViewController(
            controllerTitle: L10n.settingsTitle,
            sections: SettingsSection.eventSettings,
            themeController: MockThemeController.shared,
            rideEventSettingsStore: RideEventSettingsStoreMock(
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

    func testGeneralAppearanceWhenNotificationsAreDisabled() {
        // Given
        let viewController = EventSettingsViewController(
            controllerTitle: L10n.settingsTitle,
            sections: SettingsSection.eventSettings,
            themeController: MockThemeController.shared,
            rideEventSettingsStore: RideEventSettingsStoreMock(
                rideEventSettings: RideEventSettings(
                    isEnabled: false,
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
