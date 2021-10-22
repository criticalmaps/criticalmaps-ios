//
//  File.swift
//  
//
//  Created by Malte on 16.06.21.
//

import ComposableArchitecture
import MapFeature
import SwiftUI
import Styleguide

public struct AppView: View {
  let store: Store<AppState, AppAction>
  @ObservedObject var viewStore: ViewStore<AppState, AppAction>
  
  let minHeight: CGFloat = 56
  
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
      .edgesIgnoringSafeArea(.vertical)
      
      VStack {
        Spacer()
        
        AppNavigationView(store: store)
          .padding(.horizontal)
          .padding(.bottom, .grid(7))
          .frame(maxWidth: 400)
      }
    }
    .onAppear { viewStore.send(.onAppear) }
  }
}

// MARK: Preview
struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store<AppState, AppAction>(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        service: .noop,
        idProvider: .noop,
        mainQueue: .failing,
        uiApplicationClient: .noop,
        setUserInterfaceStyle: { _ in .none }
      )
    )
    )
  }
}
