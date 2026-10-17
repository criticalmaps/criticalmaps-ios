import SwiftUI

public extension Image {
  func iconModifier() -> some View {
    resizable().scaledToFit()
      .frame(width: 30, height: 30)
      .foregroundColor(.textPrimary)
      .padding(10)
  }
}
