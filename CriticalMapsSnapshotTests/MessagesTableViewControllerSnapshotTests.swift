//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class MessagesTableViewControllerSnapshotTests: XCTestCase {
    private let size = CGSize(width: 375, height: 667)
    private var messages: [ChatMessage] {
        [
            ChatMessage(message: "message 1", timestamp: 1_530_240_956),
            ChatMessage(message: "message 2", timestamp: 1_630_240_956),
            ChatMessage(message: "message 3", timestamp: 1_730_240_956),
            ChatMessage(message: "message 4", timestamp: 1_830_240_956)
        ]
    }

    @available(iOS 13.0.0, *)
    func testDiffableDataSource() {
        // Given
        let viewController = MessagesTableViewController<ChatMessageTableViewCell>(dataSource: MessagesDiffableDataSource())
        viewController.update(messages: messages)
        let navigationController = UINavigationController(rootViewController: viewController)

        assertViewSnapshot(matching: navigationController.view,
                           with: size,
                           precision: 0.99)
    }

    func testDefaultDataSource() {
        // Given
        let viewController = MessagesTableViewController<ChatMessageTableViewCell>(dataSource: MessagesDefaultDataSource())
        viewController.update(messages: messages)
        let navigationController = UINavigationController(rootViewController: viewController)

        assertViewSnapshot(matching: navigationController.view,
                           with: size,
                           precision: 0.99)
    }
}
