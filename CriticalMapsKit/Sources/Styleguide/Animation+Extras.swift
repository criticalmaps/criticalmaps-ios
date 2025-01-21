import Foundation
import SwiftUI

public extension Animation {
  static let cmSpring = Animation.interpolatingSpring(
    mass: 2,
    stiffness: 500,
    damping: 80,
    initialVelocity: 4
  )
}
