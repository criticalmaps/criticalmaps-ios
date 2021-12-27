import ComposableArchitecture
import Foundation
import Helpers
import SharedModels
import Styleguide
import SwiftUI
import UIApplicationClient

// MARK: State
public struct TwitterFeedState: Equatable {
  public var contentState: ContentState<[Tweet]>
  public var twitterFeedIsLoading = false
  
  public init(contentState: ContentState<[Tweet]> = .loading(.placeHolder)) {
    self.contentState = contentState
  }
}


// MARK: Actions
public enum TwitterFeedAction: Equatable {
  case onAppear
  case fetchData
  case fetchDataResponse(Result<[Tweet], NSError>)
  case openTweet(Tweet)
}


// MARK: Environment
public struct TwitterFeedEnvironment {
  public let service: TwitterFeedService
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let uiApplicationClient: UIApplicationClient
  
  public init(
    service: TwitterFeedService,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    uiApplicationClient: UIApplicationClient
  ) {
    self.service = service
    self.mainQueue = mainQueue
    self.uiApplicationClient = uiApplicationClient
  }
}


// MARK: Reducer

/// A reducer to handle twitter feature actions.
public let twitterFeedReducer =
Reducer<TwitterFeedState, TwitterFeedAction, TwitterFeedEnvironment>.combine(
  Reducer<TwitterFeedState, TwitterFeedAction, TwitterFeedEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
      return .merge(
        Effect(value: .fetchData)
      )
      
    case .fetchData:
      state.twitterFeedIsLoading = true
      return environment.service
        .getTwitterFeed()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(TwitterFeedAction.fetchDataResponse)
      
    case let .fetchDataResponse(.success(tweets)):
      state.twitterFeedIsLoading = false

      if tweets.isEmpty {
        state.contentState = .empty(.twitter)
        return .none
      }
      
      state.contentState = .results(tweets)
      return .none
    case let .fetchDataResponse(.failure(error)):
      state.twitterFeedIsLoading = false
      state.contentState = .error(
        ErrorState(
          title: ErrorState.default.title,
          body: ErrorState.default.body,
          error: error
        )
      )
      return .none
      
    case let .openTweet(tweet):
      return environment.uiApplicationClient
        .open(tweet.tweetUrl!, [:])
        .fireAndForget()
    }
  }
)
