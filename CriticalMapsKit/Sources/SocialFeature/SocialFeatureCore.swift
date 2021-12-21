import ApiClient
import ChatFeature
import ComposableArchitecture
import IDProvider
import L10n
import TwitterFeedFeature
import UIApplicationClient
import UserDefaultsClient


// MARK: State
public struct SocialState: Equatable {
  public var chatFeautureState: ChatFeatureState
  public var twitterFeedState: TwitterFeedState
  public var socialControl: SocialControl
  
  public var hasConnectivity: Bool
  
  public init(
    socialControl: SocialControl = .chat,
    chatFeautureState: ChatFeatureState = .init(),
    twitterFeedState: TwitterFeedState = .init(),
    hasConnectivity: Bool = true
  ) {
    self.socialControl = socialControl
    self.chatFeautureState = chatFeautureState
    self.twitterFeedState = twitterFeedState
    self.hasConnectivity = hasConnectivity
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
}

// MARK: Actions
public enum SocialAction: Equatable {
  case setSocialSegment(Int)
  
  case chat(ChatFeatureAction)
  case twitter(TwitterFeedAction)
}

// MARK: Environment
public struct SocialEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let uiApplicationClient: UIApplicationClient
  var locationsAndChatDataService: LocationsAndChatDataService
  var idProvider: IDProvider
  var uuid: () -> UUID
  var date: () -> Date
  var userDefaultsClient: UserDefaultsClient

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    uiApplicationClient: UIApplicationClient,
    locationsAndChatDataService: LocationsAndChatDataService,
    idProvider: IDProvider,
    uuid: @escaping () -> UUID,
    date: @escaping () -> Date,
    userDefaultsClient: UserDefaultsClient
  ) {
    self.mainQueue = mainQueue
    self.uiApplicationClient = uiApplicationClient
    self.locationsAndChatDataService = locationsAndChatDataService
    self.idProvider = idProvider
    self.uuid = uuid
    self.date = date
    self.userDefaultsClient = userDefaultsClient
  }
}

// MARK: Reducer
public let socialReducer =
Reducer<SocialState, SocialAction, SocialEnvironment>.combine(
  chatReducer.pullback(
    state: \.chatFeautureState,
    action: /SocialAction.chat,
    environment: { global in
      ChatEnvironment(
        locationsAndChatDataService: global.locationsAndChatDataService,
        mainQueue: global.mainQueue,
        idProvider: global.idProvider,
        uuid: global.uuid,
        date: global.date,
        userDefaultsClient: global.userDefaultsClient
      )
    }
  ),
  twitterFeedReducer.pullback(
    state: \.twitterFeedState,
    action: /SocialAction.twitter,
    environment: { global in TwitterFeedEnvironment(
      service: .live(),
      mainQueue: global.mainQueue,
      uiApplicationClient: global.uiApplicationClient
    )
    }
  ),
  Reducer<SocialState, SocialAction, SocialEnvironment> {
    state, action, _ in
    switch action {
    case let .setSocialSegment(segment):
      state.socialControl = .init(rawValue: segment)!
      return .none
      
    case .chat, .twitter:
      return .none
    }
  }
)
