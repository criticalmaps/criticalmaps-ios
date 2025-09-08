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
      .font(.body)
      .padding(.horizontal, .grid(4))
      .padding(.vertical, .grid(4))
      .background(Color(.brand500))
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
