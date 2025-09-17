import Foundation
import SharedModels
import Styleguide
import SwiftUI

struct RideEventView: View {
  let ride: Ride
  
  var body: some View {
    HStack(alignment: .top, spacing: .grid(2)) {
      Asset.cm.swiftUIImage
        .resizable()
        .frame(width: 44, height: 52)
        .shadow(color: .black.opacity(0.3), radius: 3)
        .accessibilityHidden(true)
        .offset(y: -4)

      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(ride.titleWithoutDatePattern)
          .font(.headline.weight(.bold))
          .foregroundColor(.textPrimary)
          .padding(.bottom, .grid(2))
        
        VStack(alignment: .leading, spacing: .grid(1)) {
          Label(ride.dateTime.humanReadableDate, systemImage: "calendar")
          
          Label(ride.rideTime, systemImage: "clock")
          
          if let location = ride.location {
            Label(location, systemImage: "mappin.and.ellipse")
          }
        }
        .font(.bodyTwo)
        .foregroundColor(.textSecondary)
      }
      .multilineTextAlignment(.leading)
      .accessibilityElement(children: .combine)
      
      Spacer()
    }
  }
}

#Preview {
  List {
    RideEventView(
      ride: Ride(
        id: 0,
        city: Ride.City(
          id: 1,
          name: "Berlin",
          timezone: TimeZone(identifier: "Europe/Berlin")!.identifier
        ),
        slug: nil,
        title: "CriticalMaps Berlin",
        description: "Enim magna ea nostrud irure elit pariatur ea dolore in. Enim magna ea nostrud irure elit pariatur ea dolore in.",
        dateTime: Date(timeIntervalSince1970: 1727905659),
        location: "Berlin",
        latitude: 53.1235,
        longitude: 13.4234,
        estimatedParticipants: nil,
        estimatedDistance: nil,
        estimatedDuration: nil,
        enabled: true,
        disabledReason: nil,
        disabledReasonMessage: nil,
        rideType: .criticalMass
      )
    )
    
    RideEventView(
      ride: Ride(
        id: 1,
        city: Ride.City(
          id: 1,
          name: "Berlin",
          timezone: TimeZone(identifier: "Europe/Berlin")!.identifier
        ),
        slug: nil,
        title: "CriticalMaps Berlin",
        description: "Enim magna ea nostrud irure elit pariatur ea dolore in. Enim magna ea nostrud irure elit pariatur ea dolore in.",
        dateTime: Date(timeIntervalSince1970: 1727905659),
        location: "Berlin",
        latitude: 53.1235,
        longitude: 13.4234,
        estimatedParticipants: nil,
        estimatedDistance: nil,
        estimatedDuration: nil,
        enabled: true,
        disabledReason: nil,
        disabledReasonMessage: nil,
        rideType: .criticalMass
      )
    )
  }
}
