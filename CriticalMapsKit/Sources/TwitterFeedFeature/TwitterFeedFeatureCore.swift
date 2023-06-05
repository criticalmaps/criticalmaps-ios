import ComposableArchitecture
import Foundation
import Helpers
import L10n
import Logger
import SharedDependencies
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
    public var tweets: IdentifiedArrayOf<TweetFeature.State>
    public var twitterFeedIsLoading = false
    public var isRefreshing = false
    public var error: ErrorState?
        
    public init(tweets: IdentifiedArrayOf<TweetFeature.State> = IdentifiedArray(uniqueElements: [Tweet].placeHolder, id: \.id)) {
      self.tweets = tweets
    }
  }
  
  // MARK: Actions
  
  public enum Action: Equatable {
    case onAppear
    case refresh
    case fetchData
    case fetchDataResponse(TaskResult<[Tweet]>)
    case tweet(id: TweetFeature.State.ID, action: TweetFeature.Action)
  }
  
  
  // MARK: Reducer
  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return EffectTask(value: .fetchData)
        
      case .refresh:
        state.isRefreshing = true
        return EffectTask(value: .fetchData)
        
      case .fetchData:
        state.twitterFeedIsLoading = true
        return .task {
          await .fetchDataResponse(TaskResult { try await twitterService.getTweets() })
        }
        
      case let .fetchDataResponse(.success(tweets)):
        state.twitterFeedIsLoading = false
        state.isRefreshing = false
        
        if tweets.isEmpty {
          state.tweets = .init(uniqueElements: [])
          return .none
        }
        
        state.tweets = IdentifiedArray(uniqueElements: tweets)
        return .none
      case let .fetchDataResponse(.failure(error)):
        logger.debug("Failed to fetch tweets with error: \(error.localizedDescription)")
        state.isRefreshing = false
        state.twitterFeedIsLoading = false
        state.error = .init(
          title: L10n.ErrorState.title,
          body: L10n.ErrorState.message,
          error: .init(error: error)
        )
        return .none
        
      case .tweet:
        return .none
      }
    }
    .forEach(\.tweets, action: /TwitterFeedFeature.Action.tweet(id:action:)) {
      TweetFeature()
    }
  }
}
