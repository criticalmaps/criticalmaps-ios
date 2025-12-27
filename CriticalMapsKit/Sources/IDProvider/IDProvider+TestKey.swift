import ComposableArchitecture
import Foundation
import UIKit.UIDevice

extension IDProvider: TestDependencyKey {
  public static let testValue: IDProvider = Self()
}
