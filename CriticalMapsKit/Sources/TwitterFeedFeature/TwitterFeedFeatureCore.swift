import ComposableArchitecture
import Foundation
import Helpers
import Logger
import SharedEnvironment
import SharedModels
import Styleguide
import SwiftUI
import UIApplicationClient

public struct TwitterFeedFeature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.mainQueue) public var mainQueue
  @Dependency(\.twitterService) public var twitterService
  @Dependency(\.uiApplicationClient) public var uiApplicationClient

  // MARK: State

  public struct State: Equatable {
    public var contentState: ContentState<[Tweet]>
    public var twitterFeedIsLoading = false
    
    public init(contentState: ContentState<[Tweet]> = .loading(.placeHolder)) {
      self.contentState = contentState
    }
  }
  
  // MARK: Actions
  
  public enum Action: Equatable {
    case onAppear
    case fetchData
    case fetchDataResponse(TaskResult<[Tweet]>)
    case openTweet(Tweet)
  }
  
  // MARK: Environment
  
  public struct Environment {
    public let service: TwitterFeedService
    public let uiApplicationClient: UIApplicationClient
    
    public init(
      service: TwitterFeedService,
      uiApplicationClient: UIApplicationClient
    ) {
      self.service = service
      self.uiApplicationClient = uiApplicationClient
    }
  }
  
  // MARK: Reducer
  
  
  public func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action, Never> {
    switch action {
    case .onAppear:
      return Effect(value: .fetchData)
    
    case .fetchData:
      state.twitterFeedIsLoading = true
      return .task {
        await .fetchDataResponse(TaskResult { try await twitterService.getTweets() })
      }

    case let .fetchDataResponse(.success(tweets)):
      state.twitterFeedIsLoading = false
    
      if tweets.isEmpty {
        state.contentState = .empty(.twitter)
        return .none
      }
    
      state.contentState = .results(tweets)
      return .none
    case let .fetchDataResponse(.failure(error)):
      logger.debug("Failed to fetch tweets with error: \(error.localizedDescription)")
      state.twitterFeedIsLoading = false
      state.contentState = .error(.default)
      return .none
    
    case let .openTweet(tweet):
      return uiApplicationClient
        .open(tweet.tweetUrl!, [:])
        .fireAndForget()
    }
  }
}
