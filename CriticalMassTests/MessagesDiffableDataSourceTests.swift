//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import XCTest

@available(iOS 13.0.0, *)
class MessagesDiffableDataSourceTests: XCTestCase {
    var dataSource: MessagesDiffableDataSource<ChatMessageTableViewCell>!
    var tableView: UITableView!

    override func setUpWithError() throws {
        tableView = UITableView(frame: .zero, style: .plain)

        dataSource = MessagesDiffableDataSource()
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
