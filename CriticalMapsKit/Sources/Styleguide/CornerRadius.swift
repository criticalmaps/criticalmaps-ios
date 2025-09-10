import SwiftUI

public extension View {
  /// Function that offers a adaptive corner radius
  func adaptiveCornerRadius(_ radius: CGFloat) -> some View {
    modifier(AdaptiveCornerRadius(radius: radius))
  }
}

private struct AdaptiveCornerRadius: ViewModifier {
  let radius: CGFloat
  
  func body(content: Content) -> some View {
    if #available(iOS 26, *) {
      content
        .clipShape(
          .rect(
            corners: .concentric(),
            isUniform: true
          )
        )
    } else {
      content
        .clipShape(
          RoundedRectangle(
            cornerRadius: radius,
            style: .continuous
          )
        )
    }
  }
}
