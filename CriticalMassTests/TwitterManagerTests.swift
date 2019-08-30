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
        let twitterManger = TwitterManager(networkLayer: networkLayer, url: Constants.twitterEndpoint)
        return (twitterManger, networkLayer)
    }

    func testUpdateMessagesCallback() {
        let setup = getSetup()
        let exp = expectation(description: "Update Tweets callback called")
        var cachedTweets: [Tweet]!

        let fakeResponse = TwitterApiResponse(statuses: [Tweet(text: "Hello World", created_at: Date(), user: TwitterUser(name: "Bar", screen_name: "Foo", profile_image_url_https: "haa"), id_str: "12345"), Tweet(text: "Test TEst", created_at: Date(), user: TwitterUser(name: "foo", screen_name: "Bar", profile_image_url_https: "differentURL"), id_str: "67890")])

        setup.networkLayer.mockResponse = fakeResponse

        setup.twitterManager.updateContentStateCallback = { contentState in
            // iterating through the elements is more stable as the order of the elements may be different
            switch contentState {
            case let .results(tweets):
                cachedTweets = tweets
                XCTAssertEqual(tweets.count, 2)
                for tweet in tweets {
                    XCTAssert(fakeResponse.statuses.contains(tweet))
                }
                exp.fulfill()
            default:
                XCTFail("contentState is not a result")
            }
        }
        setup.twitterManager.loadTweets()
        wait(for: [exp], timeout: 1)

        XCTAssertEqual(fakeResponse.statuses.count, cachedTweets.count)
        for tweet in cachedTweets {
            XCTAssert(fakeResponse.statuses.contains(tweet))
        }
    }

    func testLoadTweetsCompletionOnSuccess() {
        let setup = getSetup()
        let exp = expectation(description: "Update Tweets callback called")

        let fakeResponse = TwitterApiResponse(statuses: [Tweet(text: "Hello World", created_at: Date(), user: TwitterUser(name: "Test", screen_name: "Foo", profile_image_url_https: "haa"), id_str: "12345"), Tweet(text: "Test Test", created_at: Date(), user: TwitterUser(name: "Hello World", screen_name: "Bar", profile_image_url_https: "differentURL"), id_str: "67890")])

        setup.networkLayer.mockResponse = fakeResponse
        setup.twitterManager.loadTweets { _ in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setup.networkLayer.numberOfGetCalled, 1)
    }

    func testLoadTweetsCompletionOnFailure() {
        let setup = getSetup()
        let exp = expectation(description: "Update Tweets callback called")

        setup.networkLayer.mockResponse = nil
        setup.twitterManager.loadTweets { _ in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setup.networkLayer.numberOfGetCalled, 1)
    }
}
