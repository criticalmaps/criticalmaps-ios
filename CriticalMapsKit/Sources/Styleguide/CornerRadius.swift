import SwiftUI

public extension View {
  /// Function that offers a adaptive corner radius
  func adaptiveCornerRadius(_ corners: UIRectCorner, _ radius: CGFloat) -> some View {
    modifier(AdaptiveCornerRadius(corners: corners, radius: radius))
  }
}

private struct AdaptiveCornerRadius: ViewModifier {
  let corners: UIRectCorner
  let radius: CGFloat

  func body(content: Content) -> some View {
    content.clipShape(Bezier(corners: corners, radius: radius))
  }

  struct Bezier: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
      Path(
        UIBezierPath(
          roundedRect: rect,
          byRoundingCorners: corners,
          cornerRadii: CGSize(width: radius, height: radius)
        )
        .cgPath
      )
    }
  }
}
