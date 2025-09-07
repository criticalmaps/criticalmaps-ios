import SwiftUI

/// CM default ButtonStyle
public struct CMButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration
      .label
      .foregroundColor(
        configuration.isPressed
          ? Color(.textPrimaryLight).opacity(0.6)
          : Color(.textPrimaryLight)
      )
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .padding(.horizontal, .grid(4))
      .padding(.vertical, .grid(2))
      .background(Color(.brand500))
      .cornerRadius(8)
      .accessibleAnimation(
        .snappy,
        value: configuration.isPressed
      )
  }
}
