import SwiftUI

public extension Image {
  func iconModifier() -> some View {
    resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 30, height: 30)
      .foregroundColor(Color(.textPrimary))
      .padding(10)
  }
}
