import ComposableArchitecture
import ChatFeature
import L10n
import SwiftUI
import TwitterFeedFeature
import UIApplicationClient


// MARK: State
public struct SocialState: Equatable {
  public var chatFeautureState: ChatFeatureState
  public var twitterFeedState: TwitterFeedState
  
  var socialControl: SocialControl = .chat
  
  public init(
    chatFeautureState: ChatFeatureState = .init(),
    twitterFeedState: TwitterFeedState = .init()
  ) {
    self.chatFeautureState = chatFeautureState
    self.twitterFeedState = twitterFeedState
  }
  
  enum SocialControl: Int, Equatable {
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
}

// MARK: Actions
public enum SocialAction: Equatable {
  case setSocialSegment(Int)
  
  case chat(ChatFeatureAction)
  case twitter(TwitterFeedAction)
}

// MARK: Environment
public struct SocialEnvironment {
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public let uiApplicationClient: UIApplicationClient
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    uiApplicationClient: UIApplicationClient
  ) {
    self.mainQueue = mainQueue
    self.uiApplicationClient = uiApplicationClient
  }
}

// MARK: Reducer
public let socialReducer =
Reducer<SocialState, SocialAction, SocialEnvironment>.combine(
  chatReducer.pullback(
    state: \.chatFeautureState,
    action: /SocialAction.chat,
    environment: { global in
      ChatEnvironment()
    }
  ),
  twitterFeedReducer.pullback(
    state: \.twitterFeedState,
    action: /SocialAction.twitter,
    environment: { global in TwitterFeedEnvironment(
      service: .live(),
      mainQueue: global.mainQueue,
      uiApplicationClient: global.uiApplicationClient
    )}
  ),
  Reducer<SocialState, SocialAction, SocialEnvironment> {
    state, action, environment in
    switch action {
    case let .setSocialSegment(segment):
      state.socialControl = .init(rawValue: segment)!
      return .none
      
    case .chat, .twitter:
      return .none
    }
  }
)

fileprivate typealias S = SocialState
fileprivate typealias A = SocialAction

// MARK:- View
public struct SocialView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let store: Store<SocialState, SocialAction>
  @ObservedObject var viewStore: ViewStore<SocialState, SocialAction>
  
  public init(store: Store<SocialState, SocialAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  public var body: some View {
    NavigationView {
      Group {
        switch viewStore.socialControl {
        case .chat:
          ChatView(
            store: store.scope(
              state: \.chatFeautureState,
              action: SocialAction.chat
            )
          )
        case .twitter:
          TwitterFeedView(
            store: store.scope(
              state: \.twitterFeedState,
              action: SocialAction.twitter
            )
          )
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "xmark")
              .font(Font.system(size: 22, weight: .medium))
              .foregroundColor(Color(.textPrimary))
          }
        }
        
        ToolbarItem(placement: .principal) {
          Picker(
            "Social Segment",
            selection: viewStore.binding(
              get: \.socialControl.rawValue,
              send: { SocialAction.setSocialSegment(.init($0)) }
            )
          ) {
            Text(SocialState.SocialControl.chat.title).tag(0)
            Text(SocialState.SocialControl.twitter.title).tag(1)
          }
          .pickerStyle(SegmentedPickerStyle())
          .frame(maxWidth: 180)
        }
      }
    }
  }
}

// MARK: Preview
struct SocialView_Previews: PreviewProvider {
  static var previews: some View {
    SocialView(store: Store<SocialState, SocialAction>(
      initialState: SocialState(
        chatFeautureState: .init(),
        twitterFeedState: .init()
      ),
      reducer: socialReducer,
      environment: SocialEnvironment(
        mainQueue: .failing,
        uiApplicationClient: .noop
      )
    )
    )
  }
}
