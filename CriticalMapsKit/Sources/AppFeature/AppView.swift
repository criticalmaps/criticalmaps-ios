//
//  File.swift
//  
//
//  Created by Malte on 16.06.21.
//

import ComposableArchitecture
import MapFeature
import SwiftUI

public struct AppView: View {
  let store: Store<AppState, AppAction>
  @ObservedObject var viewStore: ViewStore<AppState, AppAction>
  
  public init(store: Store<AppState, AppAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    ZStack {
      MapFeatureView(
        store: store.scope(
          state: \.mapFeatureState,
          action: AppAction.map
        )
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear { viewStore.send(.onAppear) }
  }
}

// MARK: Preview
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store<AppState, AppAction>(
      initialState: AppState(
        locationsAndChatMessages: .init(
          locations: [:], chatMessages: [:]
        )
      ),
      reducer: appReducer,
      environment: AppEnvironment(
        service: .noop,
        idProvider: .noop,
        mainQueue: .failing
      )
    )
    )
  }
}
