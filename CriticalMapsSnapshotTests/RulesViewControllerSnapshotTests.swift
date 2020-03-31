//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class RulesViewControllerSnapshotTests: XCTestCase {
    func testGeneralAppearance() {
        // Given
        let viewController = RulesViewController(themeController: MockThemeController.shared)
        let navigationController = UINavigationController(rootViewController: viewController)

        // Then
        assertViewSnapshot(matching: navigationController.view)
    }
}
