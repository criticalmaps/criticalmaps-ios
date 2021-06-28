//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

class MessagesDefaultDataSourceTests: XCTestCase {
    var dataSource: MessagesDefaultDataSource<ChatMessageTableViewCell>!
    var tableView: UITableView!

    override func setUpWithError() throws {
        tableView = UITableView(frame: .zero, style: .plain)

        dataSource = MessagesDefaultDataSource()
        dataSource.configure(tableView: tableView)
    }

    override func tearDownWithError() throws {
        dataSource = nil
        tableView = nil
    }

    func testPopulateTableView() {
        dataSource.messages.append(contentsOf: ChatMessage.testData)

        XCTAssertTrue(tableView.numberOfSections == 1)
        XCTAssertTrue(tableView.numberOfRows(inSection: 0) == 4)
    }

    func testClearingTableView() {
        dataSource.messages.append(contentsOf: ChatMessage.testData)
        dataSource.messages.removeAll()

        XCTAssertTrue(tableView.numberOfSections == 1)
        XCTAssertTrue(tableView.numberOfRows(inSection: 0) == 0)
    }
}

extension ChatMessage {
    static var testData: [ChatMessage] {
        [
            ChatMessage(message: "message 1", timestamp: 111),
            ChatMessage(message: "message 1", timestamp: 111),
            ChatMessage(message: "message 2", timestamp: 121),
            ChatMessage(message: "message 3", timestamp: 311)
        ]
    }
}
