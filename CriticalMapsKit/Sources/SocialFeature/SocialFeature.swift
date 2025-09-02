import ApiClient
import ChatFeature
import ComposableArchitecture
import Foundation
import IDProvider
import L10n
import MastodonFeedFeature
import SwiftUI
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
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case dismiss
    
    case chat(ChatFeature.Action)
    case toots(TootFeedFeature.Action)
  }
    
  // MARK: Reducer
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.chatFeatureState, action: \.chat) {
      ChatFeature()
    }
    
    Scope(state: \.mastodonFeedState, action: \.toots) {
      TootFeedFeature()
    }
    
    Reduce { _, action in
      switch action {
      case .dismiss:
        .run { _ in await dismiss() }
      
      case .chat, .toots, .binding:
        .none
      }
    }
  }
}
