//
//  File.swift
//  
//
//  Created by Malte on 17.06.21.
//

import ComposableArchitecture
import SwiftUI

public struct MapFeatureView: View {
  public init(store: Store<MapFeatureState, MapFeatureAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  let store: Store<MapFeatureState, MapFeatureAction>
  @ObservedObject var viewStore: ViewStore<MapFeatureState, MapFeatureAction>
  
  public var body: some View {
    ZStack {
      MapView(
        riderCoordinates: viewStore.binding(
          get: \.riders,
          send: MapFeatureAction.updateRiderCoordinates
        ),
        region: viewStore.binding(
          get: \.region,
          send: MapFeatureAction.updateRegion
        ),
        nextRide: .constant(nil)
      )
      .edgesIgnoringSafeArea(.all)
    }
  }
}
