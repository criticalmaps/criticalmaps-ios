//
//  File.swift
//  
//
//  Created by Malte on 20.06.21.
//

import Foundation

public extension IDProvider {
  static let noop = Self(
    id: { "" },
    token: { "" }
  )
}
