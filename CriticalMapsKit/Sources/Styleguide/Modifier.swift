import SwiftUI

public extension Image {
  func iconModifier() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 30, height: 30)
      .foregroundColor(Color(.textPrimary))
      .padding(10)
  }
}
