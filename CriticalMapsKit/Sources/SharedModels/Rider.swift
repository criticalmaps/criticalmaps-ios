import Foundation

public struct Rider: Identifiable, Hashable {
  public let id: String
  public let location: Location
  
  public init(id: String, location: Location) {
    self.id = id
    self.location = location
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
