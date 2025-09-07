import SwiftUI

public extension View {
  @ViewBuilder
  func adaptiveClipShape(
    _ fallbackShape: some Shape = .rect(cornerRadius: .grid(2))
  ) -> some View {
    if #available(iOS 26, *) {
      self
    } else {
      clipShape(fallbackShape)
    }
  }
}
