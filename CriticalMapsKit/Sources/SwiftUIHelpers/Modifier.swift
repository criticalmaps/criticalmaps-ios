import SwiftUI

public struct AccessibleAnimation<Value: Equatable>: ViewModifier {
  @Environment(\.accessibilityReduceMotion) var reduceMotion
  let animation: Animation?
  let value: Value

  public func body(content: Content) -> some View {
    content
      .animation(reduceMotion ? nil : animation, value: value)
  }
}

public extension View {
  func accessibleAnimation(_ animation: Animation?, value: some Equatable) -> some View {
    modifier(AccessibleAnimation(animation: animation, value: value))
  }
}

#Preview {
  Text("Hello, world!")
    .modifier(AccessibleAnimation(animation: .spring, value: 0))
}
