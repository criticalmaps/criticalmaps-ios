import ComposableArchitecture
import Foundation
import L10n
import MastodonKit
import SharedModels
import Styleguide
import SwiftUI

public struct TootsListView: View {
  @State private var store: StoreOf<TootFeedFeature>

  public init(store: StoreOf<TootFeedFeature>) {
    self.store = store
  }

  public var body: some View {
    if store.isLoading, !store.isRefreshing {
      LoadingView()
    } else {
      ContentView(store: store)
        .refreshable {
          await store.send(.refresh).finish()
        }
    }
  }
}

// MARK: - Subviews

private struct LoadingView: View {
  var body: some View {
    VStack {
      Spacer()
      ProgressView {
        Text("Loading")
          .foregroundColor(.textPrimary)
          .font(.bodyOne)
      }
      Spacer()
    }
  }
}

private struct ContentView: View {
  let store: StoreOf<TootFeedFeature>

  var body: some View {
    if store.toots.isEmpty {
      EmptyStateView(
        emptyState: .mastodon,
        buttonAction: { store.send(.fetchData) },
        buttonText: L10n.EmptyState.reload
      )
    } else if let error = store.error {
      ErrorStateView(
        errorState: error,
        buttonAction: { store.send(.fetchData) },
        buttonText: L10n.EmptyState.reload
      )
    } else {
      ZStack {
        Color.backgroundPrimary
          .ignoresSafeArea()

        List {
          ForEach(store.scope(state: \.toots, action: \.toot), id: \.id) { childStore in
            TootView(store: childStore)
              .onAppear {
                if childStore.id == store.toots.last?.id, store.hasMore {
                  store.send(.loadNextPage)
                }
              }
          }
          if store.isLoadingNextPage {
            ProgressView()
              .padding()
              .frame(maxWidth: .infinity)
          }
        }
        .listRowBackground(Color.backgroundPrimary)
        .listStyle(PlainListStyle())
      }
    }
  }
}

// MARK: - Preview

#Preview {
  Group {
    TootsListView(
      store: StoreOf<TootFeedFeature>(
        initialState: .init(toots: IdentifiedArray(uniqueElements: [TootFeature.State].placeHolder)),
        reducer: { TootFeedFeature()._printChanges() }
      )
    )

    TootsListView(store: .placeholder)
      .redacted(reason: .placeholder)
  }
}

// MARK: - Helper

public extension EmptyState {
  static let mastodon = Self(
    icon: Asset.toot.image,
    text: L10n.Twitter.noData,
    message: NSAttributedString(string: L10n.Twitter.Empty.message)
  )
}
