import ComposableArchitecture
import Foundation
import MastodonFeedFeature
import MastodonKit
import Testing

@Suite
@MainActor
struct TootFeatureTests {
  let status = TootFeature.State(
    id: "123",
    createdAt: Date(timeIntervalSince1970: 0),
    uri: "https://mastodon.social/@criticalmaps",
    accountURL: "https://mastodon.social/account",
    accountAvatar: "",
    accountDisplayName: "displayname",
    accountAcct: "account",
    content: HTMLString(stringValue: "")
  )
  
  @Test("Open toot should open Mastodon URL")
  func openToot() async throws {
    let openedUrl = LockIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: status,
      reducer: { TootFeature() },
      withDependencies: {
        $0.uiApplicationClient.open = { @Sendable url, _ in
          openedUrl.setValue(url)
          return true
        }
      }
    )
    
    await store.send(.openTweet)
    
    openedUrl.withValue {
      #expect($0?.absoluteString == "https://mastodon.social/@criticalmaps")
    }
  }
  
  @Test("Open user should open user Mastodon URL")
  func openUser() async throws {
    let openedUrl = LockIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: status,
      reducer: { TootFeature() },
      withDependencies: {
        $0.uiApplicationClient.open = { @Sendable url, _ in
          openedUrl.setValue(url)
          return true
        }
      }
    )
    
    await store.send(.openUser)
    
    openedUrl.withValue {
      #expect($0?.absoluteString == "https://mastodon.social/account")
    }
  }
}
