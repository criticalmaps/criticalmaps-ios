import Foundation
import SwiftUI

public struct DeviceRotationViewModifier: ViewModifier {
  public let action: (UIDeviceOrientation) -> Void

  public init(action: @escaping (UIDeviceOrientation) -> Void) {
    self.action = action
  }
  
  public func body(content: Content) -> some View {
    content
      .onAppear()
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
        action(UIDevice.current.orientation)
      }
  }
}

public extension View {
  func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
    self.modifier(DeviceRotationViewModifier(action: action))
  }
}
