import ApiClient
import ChatFeature
import ComposableArchitecture
import Foundation
import IDProvider
import L10n
import TwitterFeedFeature
import UIApplicationClient
import UserDefaultsClient

public enum SocialFeature {
  // MARK: State
  
  public struct State: Equatable {
    public var chatFeautureState: ChatFeatureState
    public var twitterFeedState: TwitterFeedFeature.State
    public var socialControl: SocialControl

    public var hasConnectivity: Bool

    public init(
      socialControl: SocialControl = .chat,
      chatFeautureState: ChatFeatureState = .init(),
      twitterFeedState: TwitterFeedFeature.State = .init(),
      hasConnectivity: Bool = true
    ) {
      self.socialControl = socialControl
      self.chatFeautureState = chatFeautureState
      self.twitterFeedState = twitterFeedState
      self.hasConnectivity = hasConnectivity
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

    case chat(ChatFeatureAction)
    case twitter(TwitterFeedFeature.Action)
  }

  // MARK: Environment

  public struct Environment {
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

  public static let reducer =
  Reducer<SocialFeature.State, SocialFeature.Action, SocialFeature.Environment>.combine(
      chatReducer.pullback(
        state: \.chatFeautureState,
        action: /SocialFeature.Action.chat,
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
      TwitterFeedFeature.reducer.pullback(
        state: \.twitterFeedState,
        action: /SocialFeature.Action.twitter,
        environment: { global in
          TwitterFeedFeature.Environment(
            service: .live(),
            mainQueue: global.mainQueue,
            uiApplicationClient: global.uiApplicationClient
          )
        }
      ),
      Reducer<SocialFeature.State, SocialFeature.Action, SocialFeature.Environment> { state, action, _ in
        switch action {
        case let .setSocialSegment(segment):
          state.socialControl = .init(rawValue: segment)!
          return .none

        case .chat, .twitter:
          return .none
        }
      }
    )
}
