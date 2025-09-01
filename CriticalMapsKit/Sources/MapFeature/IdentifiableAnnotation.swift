import MapKit
import SharedModels

public class IdentifiableAnnotation: MKPointAnnotation {
  public enum UserType: Int, Decodable {
    case friend
    case user
  }
  
  var type: UserType = .user
  var identifier: String
  
  var location: Location {
    didSet {
      coordinate = location.coordinate.asCLLocationCoordinate
    }
  }
  
  init(location: Location, identifier: String) {
    self.identifier = identifier
    self.location = location
    super.init()
    coordinate = location.coordinate.asCLLocationCoordinate
  }
}
