import ApiClient
import ChatFeature
import ComposableArchitecture
import Foundation
import IDProvider
import L10n
import MastodonFeedFeature
import UIApplicationClient
import UserDefaultsClient

@Reducer
public struct SocialFeature {
  public init() {}
    
  // MARK: State
  
  @ObservableState
  public struct State: Equatable {
    public var chatFeatureState: ChatFeature.State
    public var mastodonFeedState: TootFeedFeature.State
    public var socialControl: SocialControl
        
    public init(
      socialControl: SocialControl = .chat,
      chatFeatureState: ChatFeature.State = .init(),
      mastodonFeedState: TootFeedFeature.State = .init()
    ) {
      self.socialControl = socialControl
      self.chatFeatureState = chatFeatureState
      self.mastodonFeedState = mastodonFeedState
    }
  }
  
  public enum SocialControl: Int, Equatable {
    case chat, toots
    
    var title: String {
      switch self {
      case .chat:
        return L10n.Chat.title
      case .toots:
        return "Mastodon"
      }
    }
  }
  
  // MARK: Actions
  
  public enum Action: Equatable {
    case setSocialSegment(SocialControl)
    
    case chat(ChatFeature.Action)
    case toots(TootFeedFeature.Action)
  }
    
  // MARK: Reducer
  
  public var body: some ReducerOf<Self> {
    Scope(
      state: \.chatFeatureState,
      action: \.chat
    ) {
      ChatFeature()
    }
    
    Scope(
      state: \.mastodonFeedState,
      action: \.toots
    ) {
      TootFeedFeature()
    }
    
    Reduce<State, Action> { state, action in
      switch action {
      case let .setSocialSegment(segment):
        state.socialControl = segment
        return .none
      
      case .chat, .toots:
        return .none
      }
    }
  }
}
