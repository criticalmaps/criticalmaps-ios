import Foundation

public struct GPXRoute: Codable, Equatable, Sendable {
  public var name: String?
  public var coordinates: [Coordinate]

  public init(name: String? = nil, coordinates: [Coordinate]) {
    self.name = name
    self.coordinates = coordinates
  }
}

// MARK: - Parse Error

public enum GPXParseError: LocalizedError, Equatable, Sendable {
  case malformedXML
  case noCoordinatesFound

  public var errorDescription: String? {
    switch self {
    case .malformedXML:
      "The file could not be read as a valid GPX file."
    case .noCoordinatesFound:
      "The GPX file does not contain any route coordinates."
    }
  }
}

// MARK: - Parser

public enum GPXParser {
  public static func parse(data: Data) throws -> GPXRoute {
    let delegate = ParserDelegate()
    let parser = XMLParser(data: data)
    parser.delegate = delegate
    guard parser.parse() else {
      throw GPXParseError.malformedXML
    }
    guard !delegate.coordinates.isEmpty else {
      throw GPXParseError.noCoordinatesFound
    }
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
