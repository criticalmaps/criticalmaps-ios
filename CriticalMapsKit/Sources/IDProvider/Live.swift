import Foundation
import UIKit.UIDevice

public extension IDProvider {
  static func live(
    deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString,
    currentDate: @escaping () -> Date = Date.init
  ) -> Self {
    Self(
      id: { IDProvider.hash(id: deviceID, currentDate: currentDate) },
      token: { deviceID }
    )
  }
}
