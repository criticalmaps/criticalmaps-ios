//
//  File.swift
//  
//
//  Created by Malte on 27.06.21.
//

import ComposableArchitecture
import MapKit
import SwiftUI

public struct UserTrackingButton: View {
  let store: Store<UserTrackingState, UserTrackingAction>
  @ObservedObject var viewStore: ViewStore<UserTrackingState, UserTrackingAction>
  
  public init(store: Store<UserTrackingState, UserTrackingAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    Button(
      action: {
        viewStore.send(.nextTrackingMode)
      },
      label: {
        switch viewStore.userTrackingMode {
        case .follow:
          Image(systemName: "location.fill")
            .iconModifier()
        case .followWithHeading:
          Image(systemName: "location.north.line.fill")
            .iconModifier()
        case .none:
          Image(systemName: "location")
            .iconModifier()
        @unknown default:
          fatalError()
        }
      }
    )
  }
}

