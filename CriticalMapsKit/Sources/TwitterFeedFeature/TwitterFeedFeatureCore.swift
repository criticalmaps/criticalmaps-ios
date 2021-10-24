import Foundation
import SharedModels
import SwiftUI
import ComposableArchitecture

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
}

// MARK: Environment
public struct TwitterFeedEnvironment {
  public let service: TwitterFeedService
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(
    service: TwitterFeedService = .live(),
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.service = service
    self.mainQueue = mainQueue
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
    Group {
      if viewStore.twitterFeedIsLoading {
        Text("loading tweets")
          .frame(maxHeight: .infinity)
      } else {
        List(viewStore.tweets) { tweet in
          Text(tweet.text)
        }
        .listStyle(InsetListStyle())
      }
    }
    .onAppear { viewStore.send(.onAppear) }
  }
}

// MARK: Preview
struct TwitterFeedView_Previews: PreviewProvider {
  static var previews: some View {
    TwitterFeedView(store: Store<TwitterFeedState, TwitterFeedAction>(
      initialState: TwitterFeedState(),
      reducer: twitterFeedReducer,
      environment: TwitterFeedEnvironment(
        service: .noop,
        mainQueue: .failing
      )
    )
    )
  }
}
