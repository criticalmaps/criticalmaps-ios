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
    let name = delegate.name.flatMap { $0.isEmpty ? nil : $0 }
    return GPXRoute(name: name, coordinates: delegate.coordinates)
  }
}

private final class ParserDelegate: NSObject, XMLParserDelegate, @unchecked Sendable {
  var name: String?
  var coordinates: [Coordinate] = []

  private var isCapturingName = false
  private var capturedText = ""
  private var hasSetName = false

  func parser(
    _ parser: XMLParser,
    didStartElement elementName: String,
    namespaceURI _: String?,
    qualifiedName _: String?,
    attributes: [String: String] = [:]
  ) {
    switch elementName {
    case "trkpt", "wpt", "rtept":
      guard let latStr = attributes["lat"], let lonStr = attributes["lon"],
            let lat = Double(latStr), let lon = Double(lonStr) else { return }
      coordinates.append(Coordinate(latitude: lat, longitude: lon))
    case "name":
      isCapturingName = true
      capturedText = ""
    default:
      break
    }
  }

  func parser(_ parser: XMLParser, foundCharacters string: String) {
    if isCapturingName {
      capturedText += string
    }
  }

  func parser(
    _ parser: XMLParser,
    didEndElement elementName: String,
    namespaceURI _: String?,
    qualifiedName _: String?
  ) {
    if elementName == "name" {
      isCapturingName = false
      if !hasSetName {
        let trimmed = capturedText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
          name = trimmed
          hasSetName = true
        }
      }
    }
  }
}
