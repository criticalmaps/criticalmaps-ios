import Foundation
import SwiftUI

extension Animation {
  public static let cmSpring = Animation.interpolatingSpring(
      mass: 2,
      stiffness: 500,
      damping: 80,
      initialVelocity: 4
    )
}
