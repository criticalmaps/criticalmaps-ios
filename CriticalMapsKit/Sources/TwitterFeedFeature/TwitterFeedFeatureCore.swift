import Foundation
import SharedModels
import SwiftUI
import ComposableArchitecture
import UIApplicationClient

// MARK: State
public struct TwitterFeedState: Equatable {
  public var tweets: [Tweet]
  public var twitterFeedIsLoading = false
  
  public init(tweets: [Tweet] = []) {
    self.tweets = tweets
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
    service: TwitterFeedService = .live(),
    mainQueue: AnySchedulerOf<DispatchQueue>,
    uiApplicationClient: UIApplicationClient
  ) {
    self.service = service
    self.mainQueue = mainQueue
    self.uiApplicationClient = uiApplicationClient
  }
}

// MARK: Reducer
public let twitterFeedReducer =
Reducer<TwitterFeedState, TwitterFeedAction, TwitterFeedEnvironment>.combine(
  Reducer<TwitterFeedState, TwitterFeedAction, TwitterFeedEnvironment> {
    state, action, environment in
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
      state.tweets = tweets
      return .none
    case let .fetchDataResponse(.failure(error)):
      state.twitterFeedIsLoading = false
      print(error)
      return .none
      
    case let .openTweet(tweet):
      return environment.uiApplicationClient
        .open(tweet.tweetUrl!, [:])
        .fireAndForget()
    }
  }
)

// MARK:- View
public struct TwitterFeedView: View {
  let store: Store<TwitterFeedState, TwitterFeedAction>
  @ObservedObject var viewStore: ViewStore<TwitterFeedState, TwitterFeedAction>
  
  public init(store: Store<TwitterFeedState, TwitterFeedAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    TweetListView(
      store: viewStore.twitterFeedIsLoading
      ? .placeholder
      : self.store
    )
    .redacted(reason: viewStore.twitterFeedIsLoading ? .placeholder : [])
    .onAppear { viewStore.send(.onAppear) }
  }
}

// MARK: Preview
struct TwitterFeedView_Previews: PreviewProvider {
  static var previews: some View {
    TwitterFeedView(
      store: Store<TwitterFeedState, TwitterFeedAction>(
        initialState: TwitterFeedState(),
        reducer: twitterFeedReducer,
        environment: TwitterFeedEnvironment(
          service: .noop,
          mainQueue: .failing,
          uiApplicationClient: .noop
        )
      )
    )
  }
}

public extension Array where Element == Tweet {
  static let placeHolder: Self = [0,1,2,3,4].map {
    Tweet(
      id: String($0),
      text: String("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore".dropLast($0)),
      createdAt: .init(timeIntervalSinceNow: TimeInterval($0)),
      user: .init(
        name: "Critical Maps",
        screenName: "@maps",
        profileImageUrl: ""
      )
    )
  }
}

extension Store where State == TwitterFeedState, Action == TwitterFeedAction {
  static let placeholder = Store(
    initialState: .init(tweets: .placeHolder),
    reducer: .empty,
    environment: ()
  )
}
