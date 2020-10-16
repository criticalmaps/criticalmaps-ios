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
        let twitterManger = TwitterManager(networkLayer: networkLayer, request: TwitterRequest())
        return (twitterManger, networkLayer)
    }

    func testUpdateMessagesCallback() {
        let setup = getSetup()
        let exp = expectation(description: "Update Tweets callback called")
        var cachedTweets: [Tweet]!

        let fakeResponse = TwitterApiResponse.TestData.fakeResponse
        setup.networkLayer.mockResponse = fakeResponse

        setup.twitterManager.updateContentStateCallback = { contentState in
            // iterating through the elements is more stable as the order of the elements may be different
            switch contentState {
            case let .results(tweets):
                cachedTweets = tweets
                XCTAssertEqual(tweets.count, Tweet.TestData.fakeTweets.count)
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

        setup.networkLayer.mockResponse = TwitterApiResponse.TestData.fakeResponse
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

    func testLoadTweetsCompletionOnSuccessShouldProduceContentState() {
        // given
        let setup = getSetup()
        let tweetCallbackExpectation = expectation(description: "Update Tweets callback called")
        let contentStateExpectation = expectation(description: "ContentStateCallback succeded")
        setup.networkLayer.mockResponse = TwitterApiResponse.TestData.fakeResponse
        var contentStateCallback: ContentState<[Tweet]>?

        // when
        setup.twitterManager.updateContentStateCallback = { state in
            contentStateCallback = state
            contentStateExpectation.fulfill()
        }
        setup.twitterManager.loadTweets { _ in
            tweetCallbackExpectation.fulfill()
        }
        // then
        wait(for: [tweetCallbackExpectation, contentStateExpectation], timeout: 1)
        XCTAssertNotNil(contentStateCallback)
    }

    func testLoadTweetsCompletionOnSuccessShouldProduceResultContentState() {
        // given
        let setup = getSetup()
        let tweetCallbackExpectation = expectation(description: "Update Tweets callback called")
        let contentStateExpectation = expectation(description: "ContentStateCallback succeded")
        setup.networkLayer.mockResponse = TwitterApiResponse.TestData.fakeResponse
        var contentStateCallback: ContentState<[Tweet]>?

        // when
        setup.twitterManager.updateContentStateCallback = { state in
            contentStateCallback = state
            contentStateExpectation.fulfill()
        }
        setup.twitterManager.loadTweets { _ in
            tweetCallbackExpectation.fulfill()
        }
        // then
        wait(for: [tweetCallbackExpectation, contentStateExpectation], timeout: 1)
        switch contentStateCallback! {
        case .results:
            break // means success
        default:
            XCTFail()
        }
    }

    func testLoadTweetsCompletionOnSuccessShouldProduceErrorContentState() {
        // given
        let setup = getSetup()
        let tweetCallbackExpectation = expectation(description: "Update Tweets callback called")
        let contentStateExpectation = expectation(description: "ContentStateCallback succeded")
        setup.networkLayer.mockResponse = nil
        var contentStateCallback: ContentState<[Tweet]>?

        // when
        setup.twitterManager.updateContentStateCallback = { state in
            contentStateCallback = state
            contentStateExpectation.fulfill()
        }
        setup.twitterManager.loadTweets { _ in
            tweetCallbackExpectation.fulfill()
        }
        // then
        wait(for: [tweetCallbackExpectation, contentStateExpectation], timeout: 1)
        switch contentStateCallback! {
        case .error:
            break // means success
        default:
            XCTFail()
        }
    }
}

private extension TwitterApiResponse {
    enum TestData {
        static let fakeResponse = TwitterApiResponse(statuses: Tweet.TestData.fakeTweets)
    }
}

private extension Tweet {
    enum TestData {
        static let fakeTweets: [Tweet] = [
            Tweet(text: "Hello World", createdAt: Date(), user: TwitterUser(name: "Test", screenName: "Foo", profileImageUrl: "haa"), id: "12345"),
            Tweet(text: "Test Test", createdAt: Date(), user: TwitterUser(name: "Hello World", screenName: "Bar", profileImageUrl: "differentURL"), id: "67890"),
        ]
    }
}
