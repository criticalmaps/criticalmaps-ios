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
          ? Color.textPrimaryLight.opacity(0.6)
          : Color.textPrimaryLight
      )
      .font(.headline)
      .padding(.horizontal, .grid(4))
      .padding(.vertical, .grid(4))
      .modifier(CMButtonBackground(isEnabled: isEnabled))
      .scaleEffect(configuration.isPressed ? 0.96 : 1)
      .accessibleAnimation(
        .snappy(duration: 0.24),
        value: configuration.isPressed
      )
  }
}

/// Brand button background: a tinted, interactive Liquid Glass capsule on iOS 26
private struct CMButtonBackground: ViewModifier {
  let isEnabled: Bool

  func body(content: Content) -> some View {
    if #available(iOS 26, *) {
      content
        .glassEffect(
          .regular.tint(Color.brand500.opacity(isEnabled ? 1 : 0.4)).interactive(),
          in: .capsule
        )
    } else {
      content
        .background(Color.brand500.opacity(isEnabled ? 1.0 : 0.4))
        .clipShape(.rect(cornerRadius: .grid(2)))
    }
  }
}

public extension ButtonStyle where Self == CMButtonStyle {
  static var criticalMaps: CMButtonStyle {
    CMButtonStyle()
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
