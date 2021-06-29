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
    var accessiblityLabel: String {
      switch viewStore.userTrackingMode {
      case .follow:
        return "Follow"
      case .followWithHeading:
        return "Follow with heading"
      case .none:
        return "Don't follow"
      @unknown default:
        return ""
      }
    }
    
    return Button(
      action: {
        viewStore.send(.nextTrackingMode)
      },
      label: {
        iconImage
          .accessibility(hidden: true)
      }
    )
    .accessibility(label: Text(accessiblityLabel))
  }
  
  var iconImage: some View {
    switch viewStore.userTrackingMode {
    case .follow:
      return Image(systemName: "location.fill")
        .iconModifier()
    case .followWithHeading:
      return Image(systemName: "location.north.line.fill")
        .iconModifier()
    case .none:
      return Image(systemName: "location")
        .iconModifier()
    @unknown default:
      return Image(systemName: "location")
        .iconModifier()
    }
  }
}

