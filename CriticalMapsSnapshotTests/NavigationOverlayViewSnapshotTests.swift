//
// Created for CriticalMaps in 2021

@testable import CriticalMaps
import MapKit
import XCTest

class NavigationOverlayViewSnapshotTests: XCTestCase {
    private let size = CGSize(width: 85 * 4, height: 56)

    func test_generalApperance() {
        let mockViewController: () -> UIViewController = { UIViewController() }

        let chatButton = ChatNavigationButton()

        let sut = NavigationOverlayViewController(navigationItems: [
            .init(representation: .view(UserTrackingButton(mapView: MKMapView())),
                  action: .none,
                  accessibilityIdentifier: "Follow"),
            .init(representation: .button(chatButton),
                  action: .navigation(viewController: mockViewController),
                  accessibilityIdentifier: "Chat"),
            .init(representation: .icon(Asset.knigge.image, accessibilityLabel: L10n.Rules.title),
                  action: .navigation(viewController: mockViewController),
                  accessibilityIdentifier: L10n.Rules.title),
            .init(representation: .icon(Asset.settings.image, accessibilityLabel: L10n.Settings.title),
                  action: .navigation(viewController: mockViewController),
                  accessibilityIdentifier: L10n.Settings.title),
        ])

        // Then
        assertViewSnapshot(
            matching: sut.view,
            with: size,
            precision: 0.99
        )
    }

    func test_generalApperance_withChatBadge() {
        let mockViewController: () -> UIViewController = { UIViewController() }

        let chatButton = ChatNavigationButton()
        chatButton.unreadCount = 23

        let sut = NavigationOverlayViewController(navigationItems: [
            .init(representation: .view(UserTrackingButton(mapView: MKMapView())),
                  action: .none,
                  accessibilityIdentifier: "Follow"),
            .init(representation: .button(chatButton),
                  action: .navigation(viewController: mockViewController),
                  accessibilityIdentifier: "Chat"),
            .init(representation: .icon(Asset.knigge.image, accessibilityLabel: L10n.Rules.title),
                  action: .navigation(viewController: mockViewController),
                  accessibilityIdentifier: L10n.Rules.title),
            .init(representation: .icon(Asset.settings.image, accessibilityLabel: L10n.Settings.title),
                  action: .navigation(viewController: mockViewController),
                  accessibilityIdentifier: L10n.Settings.title),
        ])

        // Then
        assertViewSnapshot(
            matching: sut.view,
            with: size,
            precision: 0.99
        )
    }
}
