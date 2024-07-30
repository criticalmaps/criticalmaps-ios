import ComposableArchitecture
import Foundation
import MastodonFeedFeature
import MastodonKit
import XCTest

final class TootFeatureTests: XCTestCase {
  let status = Status(
    id: "123",
    uri: "https://mastodon.social/@criticalmaps",
    url: nil,
    account: .init(
      id: "ID",
      username: "user",
      acct: "account",
      displayName: "displayname",
      note: "",
      url: "https://mastodon.social/account",
      avatar: "",
      avatarStatic: "",
      header: "",
      headerStatic: "",
      locked: false,
      createdAt: Date(timeIntervalSince1970: 0),
      followersCount: 1,
      followingCount: 2,
      statusesCount: 3
    ),
    inReplyToID: nil,
    inReplyToAccountID: nil,
    content: "",
    createdAt: Date(timeIntervalSince1970: 1),
    emojis: [],
    reblogsCount: 3,
    favouritesCount: 4,
    reblogged: nil,
    favourited: nil,
    bookmarked: nil,
    sensitive: nil,
    spoilerText: "",
    visibility: .public,
    mediaAttachments: [],
    mentions: [],
    tags: [],
    application: nil,
    language: "",
    reblog: nil,
    pinned: false,
    card: nil,
    repliesCount: 44
  )
  
  @MainActor
  func test_openTweet() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: status,
      reducer: { TootFeature() }
    )
    store.dependencies.uiApplicationClient.open = { @Sendable url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    await store.send(.openTweet)
    
    await openedUrl.withValue {
      XCTAssertEqual($0?.absoluteString, "https://mastodon.social/@criticalmaps")
    }
  }
  
  @MainActor
  func test_openUser() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: status,
      reducer: { TootFeature() }
    )
    store.dependencies.uiApplicationClient.open = { @Sendable url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    await store.send(.openUser)
    
    await openedUrl.withValue {
      XCTAssertEqual($0?.absoluteString, "https://mastodon.social/account")
    }
  }
}
