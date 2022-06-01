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
  func accessibleAnimation<Value: Equatable>(_ animation: Animation?, value: Value) -> some View {
    modifier(AccessibleAnimation(animation: animation, value: value))
  }
}

struct MyModifier_Previews: PreviewProvider {
  static var previews: some View {
    Text("Hello, world!")
      .modifier(AccessibleAnimation(animation: .easeOut, value: 0))
  }
}
