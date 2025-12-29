import ComposableArchitecture
import Foundation
import L10n
@testable import MastodonFeedFeature
import MastodonKit
import Testing

@Suite
@MainActor
struct TootFeedFeatureTests {
  // MARK: - Initial Load Tests

  @Test
  func `Initial load fetches latest toots without lastId`() async throws {
    let receivedLastId = LockIsolated<String?>(nil)

    let mockToots: [MastodonKit.Status] = [
      .mock(id: "1"),
      .mock(id: "2"),
      .mock(id: "3")
    ]

    let store = TestStore(
      initialState: TootFeedFeature.State(),
      reducer: { TootFeedFeature() },
      withDependencies: {
        $0.tootService.getToots = { @Sendable lastId in
          receivedLastId.setValue(lastId)
          return mockToots
        }
      }
    )

    await store.send(.onAppear)

    await store.receive(\.fetchData) {
      $0.isLoading = true
    }

    await store.receive(\.fetchDataResponse.success) {
      $0.isLoading = false
      $0.isRefreshing = false
      $0.toots = IdentifiedArray(
        uniqueElements: mockToots.map(TootFeature.State.init)
      )
    }

    receivedLastId.withValue {
      #expect($0 == nil, "Initial load should fetch with nil lastId")
    }
  }

  @Test
  func `OnAppear does not trigger fetch when toots already exist`() async {
    let existingToot = TootFeature.State(
      id: "existing",
      createdAt: Date(),
      uri: "https://mastodon.social/existing",
      accountURL: "https://mastodon.social/@user",
      accountAvatar: "",
      accountDisplayName: "User",
      accountAcct: "user",
      content: HTMLString(stringValue: "Existing")
    )

    let store = TestStore(
      initialState: TootFeedFeature.State(toots: [existingToot]),
      reducer: { TootFeedFeature() }
    )

    await store.send(.onAppear)
  }

  // MARK: - Refresh Tests

  @Test
  func `Refresh keeps existing toots visible and fetches latest`() async throws {
    let receivedLastId = LockIsolated<String?>(nil)

    let existingToots = [
      TootFeature.State(
        id: "old-1",
        createdAt: Date(),
        uri: "https://mastodon.social/old-1",
        accountURL: "https://mastodon.social/@user",
        accountAvatar: "",
        accountDisplayName: "User",
        accountAcct: "user",
        content: HTMLString(stringValue: "Old 1")
      ),
      TootFeature.State(
        id: "old-2",
        createdAt: Date(),
        uri: "https://mastodon.social/old-2",
        accountURL: "https://mastodon.social/@user",
        accountAvatar: "",
        accountDisplayName: "User",
        accountAcct: "user",
        content: HTMLString(stringValue: "Old 2")
      )
    ]

    let newToots: [MastodonKit.Status] = [
      .mock(id: "new-1"),
      .mock(id: "new-2"),
      .mock(id: "new-3")
    ]

    let store = TestStore(
      initialState: TootFeedFeature.State(
        toots: IdentifiedArray(uniqueElements: existingToots)
      ),
      reducer: { TootFeedFeature() },
      withDependencies: {
        $0.tootService.getToots = { @Sendable lastId in
          receivedLastId.setValue(lastId)
          return newToots
        }
      }
    )

    await store.send(.refresh) {
      $0.isRefreshing = true
      // Toots remain visible during refresh
    }

    await store.receive(\.fetchData) {
      $0.isLoading = true
    }

    await store.receive(\.fetchDataResponse.success) {
      $0.isLoading = false
      $0.isRefreshing = false
      // Toots are replaced with new data
      $0.toots = IdentifiedArray(
        uniqueElements: newToots.map(TootFeature.State.init)
      )
    }

    receivedLastId.withValue {
      #expect($0 == nil, "Refresh should fetch with nil lastId to get latest toots")
    }
  }

  @Test
  func `Refresh does not paginate from last toot`() async throws {
    let callCount = LockIsolated(0)
    let receivedLastIds = LockIsolated<[String?]>([])

    let initialToots: [MastodonKit.Status] = [
      .mock(id: "1"),
      .mock(id: "2"),
      .mock(id: "3")
    ]

    let refreshedToots: [MastodonKit.Status] = [
      .mock(id: "4"),
      .mock(id: "5")
    ]

    let store = TestStore(
      initialState: TootFeedFeature.State(),
      reducer: { TootFeedFeature() },
      withDependencies: {
        $0.tootService.getToots = { @Sendable lastId in
          callCount.withValue { $0 += 1 }
          receivedLastIds.withValue { $0.append(lastId) }

          return callCount.value == 1 ? initialToots : refreshedToots
        }
      }
    )

    // Initial load
    await store.send(.fetchData) {
      $0.isLoading = true
    }

    await store.receive(\.fetchDataResponse.success) {
      $0.isLoading = false
      $0.isRefreshing = false
      $0.toots = IdentifiedArray(
        uniqueElements: initialToots.map(TootFeature.State.init)
      )
    }

    // Refresh - should NOT use lastId from existing toots
    await store.send(.refresh) {
      $0.isRefreshing = true
      // Toots remain visible during refresh
    }

    await store.receive(\.fetchData) {
      $0.isLoading = true
    }

    await store.receive(\.fetchDataResponse.success) {
      $0.isLoading = false
      $0.isRefreshing = false
      // Toots are replaced with refreshed data
      $0.toots = IdentifiedArray(
        uniqueElements: refreshedToots.map(TootFeature.State.init)
      )
    }

    receivedLastIds.withValue { ids in
      #expect(ids.count == 2)
      #expect(ids[0] == nil, "Initial load should use nil")
      #expect(ids[1] == nil, "Refresh should use nil, not last toot ID")
    }
  }

  // MARK: - Pagination Tests

  @Test
  func `Load next page uses lastId for pagination`() async throws {
    let receivedLastId = LockIsolated<String?>(nil)

    let existingToots = [
      TootFeature.State(
        id: "1",
        createdAt: Date(),
        uri: "https://mastodon.social/1",
        accountURL: "https://mastodon.social/@user",
        accountAvatar: "",
        accountDisplayName: "User",
        accountAcct: "user",
        content: HTMLString(stringValue: "Toot 1")
      ),
      TootFeature.State(
        id: "2",
        createdAt: Date(),
        uri: "https://mastodon.social/2",
        accountURL: "https://mastodon.social/@user",
        accountAvatar: "",
        accountDisplayName: "User",
        accountAcct: "user",
        content: HTMLString(stringValue: "Toot 2")
      )
    ]

    let newPageToots: [MastodonKit.Status] = [
      .mock(id: "3"),
      .mock(id: "4")
    ]

    let store = TestStore(
      initialState: TootFeedFeature.State(
        toots: IdentifiedArray(uniqueElements: existingToots)
      ),
      reducer: { TootFeedFeature() },
      withDependencies: {
        $0.tootService.getToots = { @Sendable lastId in
          receivedLastId.setValue(lastId)
          return newPageToots
        }
      }
    )

    await store.send(.loadNextPage) {
      $0.isLoadingNextPage = true
    }

    await store.receive(\.fetchNextPageResponse.success) {
      $0.isLoadingNextPage = false
      $0.toots.append(
        contentsOf: newPageToots.map(TootFeature.State.init)
      )
    }

    receivedLastId.withValue {
      #expect($0 == "2", "Pagination should use lastId from last toot")
    }
  }

  @Test
  func `Load next page does not trigger when already loading`() async {
    let toot = TootFeature.State(
      id: "1",
      createdAt: Date(),
      uri: "https://mastodon.social/1",
      accountURL: "https://mastodon.social/@user",
      accountAvatar: "",
      accountDisplayName: "User",
      accountAcct: "user",
      content: HTMLString(stringValue: "Toot")
    )

    var initialState = TootFeedFeature.State(toots: [toot])
    initialState.isLoadingNextPage = true

    let store = TestStore(
      initialState: initialState,
      reducer: { TootFeedFeature() }
    )

    await store.send(.loadNextPage)
  }

  @Test
  func `Load next page sets hasMore to false when empty response`() async throws {
    let toot = TootFeature.State(
      id: "1",
      createdAt: Date(),
      uri: "https://mastodon.social/1",
      accountURL: "https://mastodon.social/@user",
      accountAvatar: "",
      accountDisplayName: "User",
      accountAcct: "user",
      content: HTMLString(stringValue: "Toot")
    )

    let store = TestStore(
      initialState: TootFeedFeature.State(toots: [toot]),
      reducer: { TootFeedFeature() },
      withDependencies: {
        $0.tootService.getToots = { @Sendable _ in [] }
      }
    )

    await store.send(.loadNextPage) {
      $0.isLoadingNextPage = true
    }

    await store.receive(\.fetchNextPageResponse.success) {
      $0.isLoadingNextPage = false
      $0.hasMore = false
    }
  }

  // MARK: - Error Handling Tests

  @Test
  func `Fetch data handles errors gracefully`() async throws {
    struct TestError: Error, Equatable {}

    let store = TestStore(
      initialState: TootFeedFeature.State(),
      reducer: { TootFeedFeature() },
      withDependencies: {
        $0.tootService.getToots = { @Sendable _ in throw TestError() }
      }
    )

    await store.send(.fetchData) {
      $0.isLoading = true
    }

    await store.receive(\.fetchDataResponse.failure) {
      $0.isLoading = false
      $0.isRefreshing = false
      $0.error = .init(
        title: L10n.ErrorState.title,
        body: L10n.ErrorState.message
      )
    }
  }

  @Test
  func `Refresh handles errors and stops refreshing`() async throws {
    struct TestError: Error, Equatable {}

    let store = TestStore(
      initialState: TootFeedFeature.State(),
      reducer: { TootFeedFeature() },
      withDependencies: {
        $0.tootService.getToots = { @Sendable _ in throw TestError() }
      }
    )

    await store.send(.refresh) {
      $0.isRefreshing = true
      // Toots remain (empty in this case)
    }

    await store.receive(\.fetchData) {
      $0.isLoading = true
    }

    await store.receive(\.fetchDataResponse.failure) {
      $0.isLoading = false
      $0.isRefreshing = false
      $0.error = .init(
        title: L10n.ErrorState.title,
        body: L10n.ErrorState.message
      )
    }
  }
}

extension MastodonKit.Status {
  static func mock(id: String) -> MastodonKit.Status {
    MastodonKit.Status(
      id: id,
      uri: "https://mastodon.social/\(id)",
      url: URL(string: "https://mastodon.social/@user/\(id)"),
      account: .init(
        id: "account-\(id)",
        username: "user",
        acct: "user@mastodon.social",
        displayName: "User",
        note: "Test user bio",
        url: "https://mastodon.social/@user",
        avatar: "",
        avatarStatic: "",
        header: "",
        headerStatic: "",
        locked: false,
        createdAt: Date(timeIntervalSince1970: 0),
        followersCount: 0,
        followingCount: 0,
        statusesCount: 0
      ),
      inReplyToID: nil,
      inReplyToAccountID: nil,
      content: HTMLString(stringValue: "Content \(id)"),
      createdAt: Date(timeIntervalSince1970: 0),
      emojis: [],
      reblogsCount: 0,
      favouritesCount: 0,
      reblogged: false,
      favourited: false,
      bookmarked: false,
      sensitive: false,
      spoilerText: "",
      visibility: .public,
      mediaAttachments: [],
      mentions: [],
      tags: [],
      application: nil,
      language: nil,
      reblog: nil,
      pinned: false,
      card: nil,
      repliesCount: 0
    )
  }
}
