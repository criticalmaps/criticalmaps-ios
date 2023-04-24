import ApiClient
import ChatFeature
import ComposableArchitecture
import Foundation
import IDProvider
import L10n
import TwitterFeedFeature
import UIApplicationClient
import UserDefaultsClient

public struct SocialFeature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.isNetworkAvailable) public var isNetworkAvailable
  
  // MARK: State
  
  public struct State: Equatable {
    public var chatFeatureState: ChatFeature.State
    public var twitterFeedState: TwitterFeedFeature.State
    public var socialControl: SocialControl
        
    public init(
      socialControl: SocialControl = .chat,
      chatFeatureState: ChatFeature.State = .init(),
      twitterFeedState: TwitterFeedFeature.State = .init()
    ) {
      self.socialControl = socialControl
      self.chatFeatureState = chatFeatureState
      self.twitterFeedState = twitterFeedState
    }
  }
  
  public enum SocialControl: Int, Equatable {
    case chat, twitter
    
    var title: String {
      switch self {
      case .chat:
        return L10n.Chat.title
      case .twitter:
        return L10n.Twitter.title
      }
    }
  }
  
  // MARK: Actions
  
  public enum Action: Equatable {
    case setSocialSegment(Int)
    
    case chat(ChatFeature.Action)
    case twitter(TwitterFeedFeature.Action)
  }
    
  // MARK: Reducer
  
  public var body: some ReducerProtocol<State, Action> {
    Scope(state: \.chatFeatureState, action: /SocialFeature.Action.chat) {
      ChatFeature()
        .dependency(\.isNetworkAvailable, isNetworkAvailable)
    }
    
    Scope(state: \.twitterFeedState, action: /SocialFeature.Action.twitter) {
      TwitterFeedFeature()
    }
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .setSocialSegment(segment):
        state.socialControl = .init(rawValue: segment)!
        return .none
      
      case .chat, .twitter:
        return .none
      }
    }
  }
}
