import SwiftUI

public struct MapOverlayView<Content>: View where Content: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  
  public enum OverlayType: Equatable {
    case nextRide
    case clientOffline
    case serverOffline
    
    var icon: UIImage {
      switch self {
      case .nextRide:
        return Images.eventMarker
      case .clientOffline:
        return UIImage(systemName: "wifi.slash")!
      case .serverOffline:
        return UIImage(systemName: "wifi.slash")!
      }
    }
    
    var isError: Bool {
      switch self {
      case .nextRide:
        return false
      case .clientOffline, .serverOffline:
        return true
      }
    }
  }
  
  let isExpanded: Bool
  let isVisible: Bool
  let type: OverlayType
  let action: () -> Void
  let content: () -> Content
  
  public init(
    isExpanded: Bool,
    isVisible: Bool,
    type: OverlayType,
    action: @escaping () -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.isExpanded = isExpanded
    self.isVisible = isVisible
    self.type = type
    self.action = action
    self.content = content
  }
  
  public var body: some View {
    Button(
      action: { action() },
      label: {
        HStack {
          Image(uiImage: type.icon)
            .renderingMode(.template)
          
          if isExpanded {
            content()
            .opacity(isExpanded ? 1 : 0)
            .animation(.easeOut, value: isExpanded)
          }
        }
        .padding(.horizontal, isExpanded ? 8 : 0)
      }
    )
      .disabled(type.isError)
      .frame(minWidth: 50, minHeight: 50)
      .foregroundColor(foregroundColor)
      .background(
        Group {
          if reduceTransparency || type.isError {
            RoundedRectangle(
              cornerRadius: 12,
              style: .circular
            )
              .fill(type.isError
                    ? reduceTransparency ? Color(.attention) : Color(.attention).opacity(0.8)
                    : Color(.backgroundPrimary)
              )
          } else {
            Blur()
              .cornerRadius(12)
          }
        }
      )
      .scaleEffect(isVisible ? 1 : 0)
      .animation(.easeOut)
  }
  
  var foregroundColor: Color {
    if reduceTransparency || type.isError {
      return Color.white
    } else {
      return Color(.textPrimary)
    }
  }
}

// MARK: Preview
struct MapOverlayView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MapOverlayView(
        isExpanded: true,
        isVisible: true,
        type: .nextRide,
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
        type: .nextRide,
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
        type: .clientOffline,
        action: {},
        content: {}
      )
    }
  }
}
