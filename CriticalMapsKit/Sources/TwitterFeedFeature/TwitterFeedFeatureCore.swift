import ComposableArchitecture
import Foundation
import Helpers
import SharedModels
import Styleguide
import SwiftUI
import UIApplicationClient

public enum TwitterFeedFeature {
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
  public static let reducer =
    Reducer<TwitterFeedFeature.State, TwitterFeedFeature.Action, TwitterFeedFeature.Environment>.combine(
      Reducer<TwitterFeedFeature.State, TwitterFeedFeature.Action, TwitterFeedFeature.Environment> { state, action, environment in
        switch action {
        case .onAppear:
          return Effect(value: .fetchData)
        
        case .fetchData:
          state.twitterFeedIsLoading = true
          return .task {
            await .fetchDataResponse(TaskResult { try await environment.service.getTweets() })
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
          state.twitterFeedIsLoading = false
          state.contentState = .error(
            ErrorState(
              title: ErrorState.default.title,
              body: ErrorState.default.body
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
}
