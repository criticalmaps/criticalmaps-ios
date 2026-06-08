import Foundation

public struct GPXRoute: Codable, Equatable, Sendable {
  public var name: String?
  public var coordinates: [Coordinate]

  public init(name: String? = nil, coordinates: [Coordinate]) {
    self.name = name
    self.coordinates = coordinates
  }
}

// MARK: - Parser

public enum GPXParser {
  public static func parse(data: Data) -> GPXRoute? {
    let delegate = ParserDelegate()
    let parser = XMLParser(data: data)
    parser.delegate = delegate
    parser.parse()
    guard !delegate.coordinates.isEmpty else { return nil }
    return GPXRoute(coordinates: delegate.coordinates)
  }
}

private final class ParserDelegate: NSObject, XMLParserDelegate, @unchecked Sendable {
  var coordinates: [Coordinate] = []

  func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI _: String?,
    qualifiedName _: String?,
    attributes: [String: String] = [:]
  ) {
    switch elementName {
    case "trkpt", "wpt", "rtept":
      guard
        let latStr = attributes["lat"],
        let lonStr = attributes["lon"],
        let lat = Double(latStr),
        let lon = Double(lonStr)
      else { return }
      coordinates.append(Coordinate(latitude: lat, longitude: lon))
    default:
      break
    }
  }
}
