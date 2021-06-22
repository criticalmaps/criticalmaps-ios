//
//  File.swift
//  
//
//  Created by Malte on 20.06.21.
//

import Foundation

public struct Rider: Identifiable, Hashable {
  public let id: String
  public let location: Location
  
  public init(id: String, location: Location) {
    self.id = id
    self.location = location
  }
}
