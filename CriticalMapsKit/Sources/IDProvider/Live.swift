//
//  File.swift
//  
//
//  Created by Malte on 20.06.21.
//

import Foundation
import UIKit.UIDevice

public extension IDProvider {
  static func live(
    deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString,
    currentDate: Date = Date()
  ) -> Self {
    Self(
      id: { IDProvider.hash(id: deviceID, currentDate: currentDate) },
      token: { deviceID }
    )
  }
}
