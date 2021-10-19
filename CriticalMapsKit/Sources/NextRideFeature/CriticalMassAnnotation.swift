//
//  File.swift
//  
//
//  Created by Malte on 26.06.21.
//

import CoreLocation
import Foundation
import MapKit
import SharedModels

public class CriticalMassAnnotation: NSObject, MKAnnotation {
  let ride: Ride
  let rideCoordinate: CLLocationCoordinate2D
  
  public init?(ride: Ride) {
    guard let rideCoordinate = ride.coordinate else {
      return nil
    }
    self.rideCoordinate = rideCoordinate
    self.ride = ride
    super.init()
  }
  
  public var title: String? {
    ride.titleAndTime
  }
  
  @objc dynamic public var coordinate: CLLocationCoordinate2D {
    rideCoordinate
  }
  
  public var subtitle: String? {
    ride.location
  }
}