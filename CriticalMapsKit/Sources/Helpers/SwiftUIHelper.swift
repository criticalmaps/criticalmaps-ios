import SwiftUI

public extension View {
  func continuousCornerRadius(_ radius: CGFloat) -> some View {
    self
      .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
  }
}
