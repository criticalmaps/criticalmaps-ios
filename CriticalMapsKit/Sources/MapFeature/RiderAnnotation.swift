import MapKit
import SharedModels

/// Map Annotation that renders CM participants.
public final class RiderAnnotation: IdentifiableAnnotation {
  public let rider: Rider
  public let isActive: Bool

  public init(rider: Rider, isActive: Bool = true) {
    self.rider = rider
    self.isActive = isActive
    super.init(
      location: rider.location,
      identifier: rider.id
    )
  }
}
