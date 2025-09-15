import SwiftUI

/// CM default ButtonStyle
public struct CMButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) var isEnabled
  
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .foregroundColor(
        configuration.isPressed
          ? Color(.textPrimaryLight).opacity(0.6)
          : Color(.textPrimaryLight)
      )
      .font(.body)
      .padding(.horizontal, .grid(4))
      .padding(.vertical, .grid(4))
      .background(
        Color(.brand500)
          .opacity(isEnabled ? 1.0 : 0.4)
      )
      .if(!.iOS26) { view in
        view.clipShape(.rect(cornerRadius: .grid(2)))
      }
      .if(.iOS26) { view in
        view.clipShape(.capsule)
      }
      .scaleEffect(configuration.isPressed ? 0.96 : 1)
      .accessibleAnimation(
        .snappy(duration: 0.24),
        value: configuration.isPressed
      )
  }
}

public struct GlassButtonModifier: ViewModifier {
  public init() {}
  
  public func body(content: Content) -> some View {
    if #available(iOS 26, *) {
      content
        .buttonStyle(.glass)
    } else {
      content
    }
  }
}
