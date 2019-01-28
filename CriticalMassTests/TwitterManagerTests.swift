//
//  TwitterManagerTests.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 1/28/19.
//

@testable import CriticalMaps
import XCTest

class TwitterManagerTests: XCTestCase {
    func getSetup() -> (twitterManager: TwitterManager, networkLayer: MockNetworkLayer) {
        let networkLayer = MockNetworkLayer()
        let twitterManger = TwitterManager(networkLayer: networkLayer)
        return (twitterManger, networkLayer)
    }

    func testUpdateMessagesCallback() {
        let setup = getSetup()
        let exp = expectation(description: "Update Tweets callback called")

        let fakeResponse = TwitterApiResponse(statuses: [Tweet(text: "Hello World", created_at: Date(), user: TwitterUser(screen_name: "Foo", profile_image_url_https: "haa")), Tweet(text: "Test TEst", created_at: Date(), user: TwitterUser(screen_name: "Bar", profile_image_url_https: "differentURL"))])

        setup.networkLayer.mockResponse = fakeResponse

        setup.twitterManager.updateTweetsCallback = { tweets in
            // iterating through the elements is more stable as the order of the elements may be different
            XCTAssertEqual(tweets.count, 2)
            for tweet in tweets {
                XCTAssert(fakeResponse.statuses.contains(tweet))
            }
            exp.fulfill()
        }
        setup.twitterManager.loadTweets()
        wait(for: [exp], timeout: 1)

        let getTweetsResult = setup.twitterManager.getTweets()
        XCTAssertEqual(fakeResponse.statuses.count, getTweetsResult.count)
        for tweet in getTweetsResult {
            XCTAssert(fakeResponse.statuses.contains(tweet))
        }
    }

    func testLoadTweetsCompletionOnSuccess() {
        let setup = getSetup()
        let exp = expectation(description: "Update Tweets callback called")

        let fakeResponse = TwitterApiResponse(statuses: [Tweet(text: "Hello World", created_at: Date(), user: TwitterUser(screen_name: "Foo", profile_image_url_https: "haa")), Tweet(text: "Test TEst", created_at: Date(), user: TwitterUser(screen_name: "Bar", profile_image_url_https: "differentURL"))])

        setup.networkLayer.mockResponse = fakeResponse
        setup.twitterManager.loadTweets {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setup.networkLayer.numberOfGetCalled, 1)
    }

    func testLoadTweetsCompletionOnFailure() {
        let setup = getSetup()
        let exp = expectation(description: "Update Tweets callback called")

        setup.networkLayer.mockResponse = nil
        setup.twitterManager.loadTweets {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setup.networkLayer.numberOfGetCalled, 1)
    }
}
