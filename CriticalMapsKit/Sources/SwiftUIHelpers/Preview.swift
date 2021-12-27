import SwiftUI

/// Convenience Wrapper that will display a SwiftUI Preview on 2 different devices and themes.
public struct Preview<Content: View>: View {
  let content: Content

  public init(@ViewBuilder _ content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    Group {
      self.content
        .environment(\.colorScheme, .light)
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
        .previewDevice("iPhone 12 Pro")
        .previewDisplayName("Pro, light mode")

      self.content
        .environment(\.colorScheme, .dark)
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .previewDevice("iPhone 12 mini")
        .previewDisplayName("Mini, dark mode")
    }
  }
}
