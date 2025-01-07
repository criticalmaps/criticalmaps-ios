import ComposableArchitecture
import Foundation
import MastodonKit
import SharedModels
import Styleguide
import SwiftUI

public struct MastodonFeedView: View {
  @Bindable var store: StoreOf<TootFeedFeature>

  public init(store: StoreOf<TootFeedFeature>) {
    self.store = store
  }

  public var body: some View {
    TootsListView(store: self.store)
      .navigationBarTitleDisplayMode(.inline)
      .onAppear { store.send(.onAppear) }
  }
}

// MARK: Preview

#Preview {
  MastodonFeedView(
    store: StoreOf<TootFeedFeature>(
      initialState: .init(),
      reducer: { TootFeedFeature()._printChanges() }
    )
  )
}

// MARK: - Helper

public extension [TootFeature.State] {
  static let placeHolder: Self = [0, 1, 2, 3, 4].map {
    TootFeature.State(
      id: String($0),
      createdAt: .init(timeIntervalSince1970: TimeInterval(1635521516)),
      uri: "",
      accountURL: "",
      accountAvatar: "",
      accountDisplayName: "",
      accountAcct: "",
      content: ""
    )
  }
}

extension Store where State == TootFeedFeature.State, Action == TootFeedFeature.Action {
  static let placeholder = Store(
    initialState: .init(
      toots: IdentifiedArray(
        uniqueElements: [TootFeature.State].placeHolder
      )
    ),
    reducer: { EmptyReducer() }
  )
}
