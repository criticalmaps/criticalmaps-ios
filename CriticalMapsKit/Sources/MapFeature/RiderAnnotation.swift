import MapKit
import SharedModels

/// Map Annotation that renders CM participants.
public final class RiderAnnotation: IdentifiableAnnotation {
  public let rider: Rider

  public init(rider: Rider) {
    self.rider = rider
    super.init(
      location: rider.location,
      identifier: rider.id
    )
  }
}
