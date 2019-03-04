//
//  ChatManagerTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/26/19.
//

@testable import CriticalMaps
import XCTest

class ChatManagerTests: XCTestCase {
    func getSetup() -> (chatManager: ChatManager, networkLayer: MockNetworkLayer, dataStore: DataStore) {
        let networkLayer = MockNetworkLayer()
        let dataStore = MemoryDataStore()
        let requestManager = RequestManager(dataStore: dataStore, locationProvider: MockLocationProvider(), networkLayer: networkLayer, deviceId: UUID().uuidString, url: Constants.apiEndpoint)
        let chatManager = ChatManager(requestManager: requestManager)
        return (chatManager, networkLayer, dataStore)
    }

    func testSendMessage() {
        let setup = getSetup()
        let timeInterval = Date().timeIntervalSince1970
        setup.networkLayer.mockResponse = ApiResponse(locations: [:], chatMessages: ["1233": ChatMessage(message: "Hello World", timestamp: timeInterval)])

        let exp = expectation(description: "Wait for response")

        setup.chatManager.send(message: "Hello World") { success in

            XCTAssertTrue(success)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        guard let lastUsedBody = setup.networkLayer.lastUsedPostBody else {
            XCTFail()
            return
        }
        let messageJSONs = Array(lastUsedBody["messages"] as! [[String: Any]])
        XCTAssertEqual(messageJSONs.count, 1)

        guard let messageJSON = messageJSONs.first else {
            XCTFail()
            return
        }

        XCTAssertEqual(messageJSON["text"] as! String, "Hello World")
        XCTAssertEqual(messageJSON["timestamp"] as! TimeInterval, timeInterval, accuracy: 0.01)
        XCTAssertNotNil(messageJSON["identifier"])
    }

    func testSendMessageFails() {
        let setup = getSetup()
        setup.networkLayer.mockResponse = nil

        let exp = expectation(description: "Wait for response")

        setup.chatManager.send(message: "Hello World") { success in

            XCTAssertFalse(success)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    func testSendMessageIdentifierChanges() {
        let setup = getSetup()
        let timeInterval = Date().timeIntervalSince1970
        setup.networkLayer.mockResponse = ApiResponse(locations: [:], chatMessages: ["1233": ChatMessage(message: "Hello World", timestamp: timeInterval)])

        let firstExp = expectation(description: "Wait for response")

        setup.chatManager.send(message: "Hello World") { success in
            XCTAssertTrue(success)
            firstExp.fulfill()
        }
        wait(for: [firstExp], timeout: 1)
        guard let firstUsedBody = setup.networkLayer.lastUsedPostBody else {
            XCTFail()
            return
        }
        let messageJSON = Array(firstUsedBody["messages"] as! [[String: Any]])[0]

        let secondExp = expectation(description: "Wait for response")

        setup.chatManager.send(message: "Hello World") { success in
            XCTAssertTrue(success)
            secondExp.fulfill()
        }
        wait(for: [secondExp], timeout: 1)
        guard let secondUsedBody = setup.networkLayer.lastUsedPostBody else {
            XCTFail()
            return
        }
        let secondMessageJSON = Array(secondUsedBody["messages"] as! [[String: Any]])[0]
        XCTAssertNotEqual(messageJSON["identifier"] as! String, secondMessageJSON["identifier"] as! String)
    }

    func testUpdateMessagesCallback() {
        let setup = getSetup()
        let exp = expectation(description: "Update message callback called")

        let expectedMessages = [ChatMessage(message: "Hello", timestamp: 1), ChatMessage(message: "World", timestamp: 2)]

        setup.chatManager.updateMessagesCallback = { messages in
            // iterating through the elements is more stable as the order of the elements may be different
            XCTAssertEqual(messages.count, expectedMessages.count)
            for message in messages {
                XCTAssert(expectedMessages.contains(message))
            }
            exp.fulfill()
        }
        setup.dataStore.update(with: ApiResponse(locations: [:], chatMessages: ["1": expectedMessages[0], "2": expectedMessages[1]]))

        wait(for: [exp], timeout: 1)
    }
}
