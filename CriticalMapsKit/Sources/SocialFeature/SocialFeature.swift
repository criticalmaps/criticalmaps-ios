import ApiClient
import SwiftUICore
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
  
  @Dependency(\.dismiss) var dismiss
  
  // MARK: State
  
  @ObservableState
  public struct State: Equatable {
    public var chatFeatureState: ChatFeature.State
    public var mastodonFeedState: TootFeedFeature.State
    public var socialControl: SocialControl = .chat
        
    public init(
      chatFeatureState: ChatFeature.State = .init(),
      mastodonFeedState: TootFeedFeature.State = .init()
    ) {
      self.chatFeatureState = chatFeatureState
      self.mastodonFeedState = mastodonFeedState
    }
  }
  
  public enum SocialControl: LocalizedStringKey, CaseIterable, Hashable {
    case chat = "Chat"
    case toots = "Mastodon"
  }
  
  // MARK: Actions
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case dismiss
    
    case chat(ChatFeature.Action)
    case toots(TootFeedFeature.Action)
  }
    
  // MARK: Reducer
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.chatFeatureState, action: \.chat) {
      ChatFeature()
    }
    
    Scope(state: \.mastodonFeedState, action: \.toots) {
      TootFeedFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .dismiss:
        return .run { _ in  await dismiss() }
      
      case .chat, .toots, .binding:
        return .none
      }
    }
  }
}
