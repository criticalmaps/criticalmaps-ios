import SwiftUI

public struct MapOverlayView<Content>: View where Content: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  @Environment(\.accessibilityReduceMotion) var reduceMotion
  
  let isExpanded: Bool
  let isVisible: Bool
  let action: () -> Void
  let content: () -> Content
  
  public init(
    isExpanded: Bool,
    isVisible: Bool,
    action: @escaping () -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.isExpanded = isExpanded
    self.isVisible = isVisible
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
            .opacity(isExpanded ? 1 : 0)
            .animation(reduceMotion ? nil : .easeOut, value: isExpanded)
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
      .scaleEffect(isVisible ? 1 : 0)
      .animation(.easeOut, value: isVisible)
  }
}

// MARK: Preview
struct MapOverlayView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MapOverlayView(
        isExpanded: true,
        isVisible: true,
        action: {},
        content: {
          VStack {
            Text("Next Ride")
            Text("FRIDAY")
          }
        }
      )
      
      MapOverlayView(
        isExpanded: false,
        isVisible: true,
        action: {},
        content: {
          VStack {
            Text("Next Ride")
            Text("FRIDAY")
          }
        }
      )
      
      MapOverlayView(
        isExpanded: false,
        isVisible: true,
        action: {},
        content: {}
      )
    }
  }
}
