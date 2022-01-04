import ComposableArchitecture
import Foundation
import Styleguide
import SwiftUI

/// A view to overlay the map and indicate the next ride
public struct MapOverlayView<Content>: View where Content: View {
  public struct ViewState: Equatable {
    let isVisible: Bool
    let isExpanded: Bool
    
    public init(isVisible: Bool, isExpanded: Bool) {
      self.isVisible = isVisible
      self.isExpanded = isExpanded
    }
  }
  
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  @Environment(\.accessibilityReduceMotion) var reduceMotion
  
  let store: Store<ViewState, Never>
  @ObservedObject var viewStore: ViewStore<ViewState, Never>
  
  @State var isExpanded = false
  @State var isVisible = false
  let action: () -> Void
  let content: () -> Content
  
  public init(
    store: Store<ViewState, Never>,
    action: @escaping () -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.store = store
    self.viewStore = ViewStore(store)
    self.action = action
    self.content = content
  }
  
  public var body: some View {
    Button(
      action: { action() },
      label: {
        HStack {
          Image(uiImage: Asset.cm.image)
          
          if isExpanded {
            content()
              .transition(
                .asymmetric(
                  insertion: .opacity.animation(reduceMotion ? nil : .easeInOut(duration: 0.1).delay(0.2)),
                  removal: .opacity.animation(reduceMotion ? nil : .easeOut(duration: 0.15))
                )
              )
          }
        }
        .padding(.horizontal, isExpanded ? 8 : 0)
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
      .transition(.scale.animation(reduceMotion ? nil : .easeOut(duration: 0.2)))
      .onChange(of: viewStore.isExpanded, perform: { newValue in
        let updateAction: () -> Void = { self.isExpanded = newValue }
        reduceMotion ? updateAction() : withAnimation { updateAction() }
      })
      .onChange(of: viewStore.isVisible, perform: { newValue in
        let updateAction: () -> Void = { self.isVisible = newValue }
        reduceMotion ? updateAction() : withAnimation { updateAction() }
      })
  }
}

// MARK: Preview
struct MapOverlayView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MapOverlayView(
        store: Store<MapFeatureState, Never>(
          initialState: .init(riders: [], userTrackingMode: .init(userTrackingMode: .follow)),
          reducer: .empty,
          environment: ())
          .actionless
          .scope(state: { _ in
            MapOverlayView.ViewState(isVisible: true, isExpanded: true)
          }
        ),
        action: {},
        content: {
          VStack {
            Text("Next Ride")
            Text("FRIDAY")
          }
        }
      )
      
      MapOverlayView(
        store: Store<MapFeatureState, Never>(
          initialState: .init(riders: [], userTrackingMode: .init(userTrackingMode: .follow)),
          reducer: .empty,
          environment: ())
          .actionless
          .scope(state: { _ in
            MapOverlayView.ViewState(isVisible: true, isExpanded: true)
          }
        ),
        action: {},
        content: {
          VStack {
            Text("Next Ride")
            Text("FRIDAY")
          }
        }
      )
      
      MapOverlayView(
        store: Store<MapFeatureState, Never>(
          initialState: .init(riders: [], userTrackingMode: .init(userTrackingMode: .follow)),
          reducer: .empty,
          environment: ())
          .actionless
          .scope(state: { _ in
            MapOverlayView.ViewState(isVisible: true, isExpanded: false)
          }
        ),
        action: {},
        content: {}
      )
    }
  }
}
