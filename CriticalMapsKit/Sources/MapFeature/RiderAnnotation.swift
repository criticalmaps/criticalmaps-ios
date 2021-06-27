//
//  File.swift
//  
//
//  Created by Malte on 15.06.21.
//

import MapKit
import SharedModels

class RiderAnnotation: IdentifiableAnnnotation {
  let rider: Rider
  
  init(rider: Rider) {
    self.rider = rider
    super.init(
      location: rider.location,
      identifier: rider.id
    )
  }
}
