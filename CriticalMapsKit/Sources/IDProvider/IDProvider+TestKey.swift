import ComposableArchitecture
import Foundation
import UIKit.UIDevice

extension IDProvider: TestDependencyKey {
  public static var testValue: IDProvider = Self()
}
