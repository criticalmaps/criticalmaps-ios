import ComposableArchitecture
import Foundation
import Helpers
import L10n
import Logger
import MastodonKit
import SharedDependencies
import SharedModels
import Styleguide
import SwiftUI

@Reducer
public struct TootFeedFeature {
  public init() {}
  
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.tootService) var tootService

  // MARK: State

  @ObservableState
  public struct State: Equatable {
    public var toots: IdentifiedArrayOf<TootFeature.State>
    public var isLoading = false
    public var isRefreshing = false
    public var error: ErrorState?
        
    public init(
      toots: IdentifiedArrayOf<TootFeature.State> = []
    ) {
      self.toots = toots
    }
  }
  
  // MARK: Actions
  
  @CasePathable
  public enum Action: Equatable {
    case onAppear
    case refresh
    case fetchData
    case fetchDataResponse(TaskResult<[MastodonKit.Status]>)
    case toot(IdentifiedActionOf<TootFeature>)
  }
  
  // MARK: Reducer

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
              TaskResult { try await tootService.getToots() }
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
        logger.debug("Failed to fetch tweets with error: \(error.localizedDescription)")
        state.isRefreshing = false
        state.isLoading = false
        state.error = .init(
          title: L10n.ErrorState.title,
          body: L10n.ErrorState.message,
          error: .init(error: error)
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

extension MastodonKit.Status: @retroactive Identifiable {
  public static func == (lhs: MastodonKit.Status, rhs: MastodonKit.Status) -> Bool {
    lhs.id == rhs.id
  }
}
