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
public struct MapOverlayView<Content: View>: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  @Environment(\.accessibilityReduceMotion) var reduceMotion
  
  let store: StoreOf<MapOverlayFeature>
  
  @State private var isExpanded = false
  @State private var isVisible = false
  let content: () -> Content
  
  public init(
    store: StoreOf<MapOverlayFeature>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.store = store
    self.content = content
  }
  
  public var body: some View {
    Button(
      action: { store.send(.didTapOverlayButton) },
      label: {
        HStack {
          Image(uiImage: Asset.cm.image)
          
          if isExpanded {
            content()
              .padding(.grid(2))
              .transition(
                .asymmetric(
                  insertion: .opacity.animation(reduceMotion ? nil : .cmSpring.speed(1.6).delay(0.2)),
                  removal: .opacity.animation(reduceMotion ? nil : .cmSpring.speed(1.6))
                )
              )
          }
        }
        .padding(.horizontal, isExpanded ? .grid(2) : 0)
      }
    )
    .frame(minWidth: 50, minHeight: 50)
    .foregroundColor(reduceTransparency ? .white : Color(.textPrimary))
    .background(
      Group {
        if reduceTransparency {
          RoundedRectangle(
            cornerRadius: 12,
            style: .circular
          )
          .fill(Color(.backgroundPrimary))
        } else {
          Blur()
            .cornerRadius(12)
        }
      }
    )
    .transition(.scale.combined(with: .opacity).animation(reduceMotion ? nil : .spring(duration: 0.2)))
    .onChange(
      of: store.isExpanded,
      perform: { newValue in
        let updateAction: () -> Void = { isExpanded = newValue }
        reduceMotion ? updateAction() : withAnimation { updateAction() }
      }
    )
    .onChange(
      of: store.isVisible,
      perform: { newValue in
        let updateAction: () -> Void = { isVisible = newValue }
        reduceMotion ? updateAction() : withAnimation { updateAction() }
      }
    )
  }
}
