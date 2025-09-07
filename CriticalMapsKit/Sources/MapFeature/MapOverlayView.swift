import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI

@Reducer
public struct MapOverlayFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public init(isExpanded: Bool, isVisible: Bool) {
      self.isExpanded = isExpanded
      self.isVisible = isVisible
    }
    
    public var isExpanded: Bool
    public var isVisible: Bool
  }
  
  public enum Action: Equatable {
    case didTapOverlayButton
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .didTapOverlayButton:
        .none
      }
    }
  }
}

/// A view to overlay the map and indicate the next ride
public struct MapOverlayView: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  @Environment(\.accessibilityReduceMotion) var reduceMotion
  
  let store: StoreOf<MapOverlayFeature>
  
  public init(store: StoreOf<MapOverlayFeature>) {
    self.store = store
  }
  
  public var body: some View {
    Button(
      action: { store.send(.didTapOverlayButton) },
      label: { Asset.cm.swiftUIImage }
    )
    .frame(minWidth: 50, minHeight: 50)
    .foregroundStyle(Color(.textPrimary))
    .if(!.iOS26) { view in
      view
        .transition(
          .scale
            .combined(with: .opacity)
            .animation(reduceMotion ? nil : .snappy)
        )
    }
  }
}
