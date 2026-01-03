import ComposableArchitecture
import Foundation
import Helpers
import L10n
import MastodonKit
import os
import SharedModels
import Styleguide
import SwiftUI

@Reducer
public struct TootFeedFeature: Sendable {
  public init() {}
  
  // MARK: State

  @ObservableState
  public struct State: Equatable, Sendable {
    public var toots: IdentifiedArrayOf<TootFeature.State>
    public var isLoading = false
    public var isRefreshing = false
    public var error: ErrorState?
    public var hasMore = true
    public var isLoadingNextPage = false
        
    public init(
      toots: IdentifiedArrayOf<TootFeature.State> = []
    ) {
      self.toots = toots
    }
  }
  
  // MARK: Actions
  
  @CasePathable
  public enum Action {
    case onAppear
    case refresh
    case fetchData
    case fetchDataResponse(Result<[MastodonKit.Status], any Error>)
    case loadNextPage
    case fetchNextPageResponse(Result<[MastodonKit.Status], any Error>)
    case toot(IdentifiedActionOf<TootFeature>)
  }
  
  // MARK: Reducer
  
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.tootService) var tootService

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        guard state.toots.isEmpty else { return .none }
        return .send(.fetchData)
        
      case .refresh:
        state.isRefreshing = true
        return .send(.fetchData)

      case .fetchData:
        state.isLoading = true
        return .run { send in
          await send(
            .fetchDataResponse(
              Result { try await tootService.getToots(nil) }
            )
          )
        }
        
      case let .fetchDataResponse(.success(toots)):
        state.isLoading = false
        state.isRefreshing = false
        
        if toots.isEmpty {
          state.toots = .init(uniqueElements: [])
          return .none
        }
        
        let mappedStatuses = toots.map(TootFeature.State.init)
        state.toots = IdentifiedArray(uniqueElements: mappedStatuses)
        return .none

      case let .fetchDataResponse(.failure(error)):
        Logger.reducer.debug("Failed to fetch tweets with error: \(error)")
        state.isRefreshing = false
        state.isLoading = false
        state.error = .init(
          title: L10n.ErrorState.title,
          body: L10n.ErrorState.message
        )
        return .none
        
      case .loadNextPage:
        guard state.hasMore, !state.isLoadingNextPage, let lastId = state.toots.last?.id else { return .none }
        state.isLoadingNextPage = true
        return .run { send in
          await send(
            .fetchNextPageResponse(
              Result { try await tootService.getToots(lastId) }
            )
          )
        }

      case let .fetchNextPageResponse(.success(newToots)):
        state.isLoadingNextPage = false
        if newToots.isEmpty {
          state.hasMore = false
        } else {
          let mappedStatuses = newToots.map(TootFeature.State.init)
          state.toots.append(contentsOf: mappedStatuses)
        }
        return .none

      case let .fetchNextPageResponse(.failure(error)):
        Logger.reducer.debug("Failed to fetch next page response: \(error)")

        state.isLoadingNextPage = false
        state.hasMore = false
        state.error = .init(
          title: L10n.ErrorState.title,
          body: L10n.ErrorState.message
        )
        return .none
        
      case .toot:
        return .none
      }
    }
    .forEach(\.toots, action: \.toot) {
      TootFeature()
    }
  }
}

private extension Logger {
  /// Using your bundle identifier is a great way to ensure a unique identifier.
  private static let subsystem = "MastodonFeedFeature"
  
  /// Logs the view cycles like a view that appeared.
  static let reducer = Logger(
    subsystem: subsystem,
    category: "Reducer"
  )
}
