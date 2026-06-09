import ComposableArchitecture
import Foundation
@testable import SettingsFeature
import SharedModels
import Testing

@Suite("GPX Route Feature")
@MainActor
struct GPXRouteFeatureTests {
  // MARK: - Reducer

  @Test
  func `import button tapped sets is importing flag`() async {
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )

    await store.send(.view(.gpxImportButtonTapped)) {
      $0.isImportingGPXRoute = true
    }
  }

  @Test
  func `file selected with failure shows alert`() async {
    var initialState = SettingsFeature.State()
    initialState.isImportingGPXRoute = true

    let store = TestStore(
      initialState: initialState,
      reducer: { SettingsFeature() }
    )

    await store.send(.view(.gpxFileSelected(.failure(TestError.stub)))) {
      $0.isImportingGPXRoute = false
      $0.alert = .gpxImportFailed(error: TestError.stub)
    }
  }

  @Test
  func `file selected with valid GPX stores route in user settings`() async throws {
    @Shared(.userSettings) var userSettings = UserSettings()
    let url = try makeGPXFile(named: "Sternfahrt_2026", content: validGPXContent)

    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )

    await store.send(.view(.gpxImportButtonTapped)) {
      $0.isImportingGPXRoute = true
    }
    await store.send(.view(.gpxFileSelected(.success(url)))) {
      $0.isImportingGPXRoute = false
    }

    let expectedRoute = GPXRoute(
      name: url.lastPathComponent,
      coordinates: [
        Coordinate(latitude: 52.5200, longitude: 13.4050),
        Coordinate(latitude: 52.5210, longitude: 13.4060),
        Coordinate(latitude: 52.5220, longitude: 13.4070)
      ]
    )
    await store.receive(\.gpxRouteParsed) {
      $0.$userSettings.withLock { value in value.gpxRoute = expectedRoute }
    }

    #expect(userSettings.gpxRoute == expectedRoute)
  }

  @Test
  func `file selected with unparsable content shows alert`() async throws {
    let url = try makeGPXFile(named: "broken", content: "this is not xml at all")

    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )

    await store.send(.view(.gpxImportButtonTapped)) {
      $0.isImportingGPXRoute = true
    }
    await store.send(.view(.gpxFileSelected(.success(url)))) {
      $0.isImportingGPXRoute = false
    }
    await store.receive(\.gpxImportFailed) {
      $0.alert = .gpxImportFailed(error: GPXParseError.malformedXML)
    }
  }

  @Test
  func `file selected with GPX having no trackpoints shows alert`() async throws {
    let url = try makeGPXFile(named: "empty", content: emptyTrackGPXContent)

    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )

    await store.send(.view(.gpxImportButtonTapped)) {
      $0.isImportingGPXRoute = true
    }
    await store.send(.view(.gpxFileSelected(.success(url)))) {
      $0.isImportingGPXRoute = false
    }
    await store.receive(\.gpxImportFailed) {
      $0.alert = .gpxImportFailed(error: GPXParseError.noCoordinatesFound)
    }
  }

  @Test
  func `route removed clears GPX route from user settings`() async {
    @Shared(.userSettings) var userSettings = UserSettings(
      gpxRoute: GPXRoute(name: "Test Route", coordinates: [Coordinate(latitude: 52.5, longitude: 13.4)])
    )

    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )

    await store.send(.view(.gpxRouteRemoved)) {
      $0.$userSettings.withLock { value in value.gpxRoute = nil }
    }

    #expect(userSettings.gpxRoute == nil)
  }

  @Test
  func `gpx route parsed stores route in user settings`() async {
    @Shared(.userSettings) var userSettings = UserSettings()

    let route = GPXRoute(
      name: "Berlin Ride",
      coordinates: [Coordinate(latitude: 52.5200, longitude: 13.4050)]
    )
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )

    await store.send(.gpxRouteParsed(route)) {
      $0.$userSettings.withLock { value in value.gpxRoute = route }
    }

    #expect(userSettings.gpxRoute == route)
  }
}

// MARK: - GPXParser Unit Tests

@Suite("GPXParser")
struct GPXParserTests {
  @Test
  func `parses track points`() throws {
    let route = try GPXParser.parse(data: Data(validGPXContent.utf8))
    #expect(route.coordinates.count == 3)
    #expect(route.coordinates.first == Coordinate(latitude: 52.5200, longitude: 13.4050))
    #expect(route.coordinates.last == Coordinate(latitude: 52.5220, longitude: 13.4070))
  }

  @Test
  func `parses waypoints`() throws {
    let gpx = """
    <?xml version="1.0"?>
    <gpx version="1.1">
      <wpt lat="48.1374" lon="11.5755"><name>Munich</name></wpt>
      <wpt lat="48.1384" lon="11.5765"><name>Next</name></wpt>
    </gpx>
    """
    let route = try GPXParser.parse(data: Data(gpx.utf8))
    #expect(route.coordinates.count == 2)
    #expect(route.coordinates.first == Coordinate(latitude: 48.1374, longitude: 11.5755))
  }

  @Test
  func `parses route points`() throws {
    let gpx = """
    <?xml version="1.0"?>
    <gpx version="1.1">
      <rte><rtept lat="52.0" lon="13.0"/><rtept lat="52.1" lon="13.1"/></rte>
    </gpx>
    """
    let route = try GPXParser.parse(data: Data(gpx.utf8))
    #expect(route.coordinates.count == 2)
  }

  @Test
  func `throws noCoordinatesFound for empty track`() {
    #expect(throws: GPXParseError.noCoordinatesFound) {
      try GPXParser.parse(data: Data(emptyTrackGPXContent.utf8))
    }
  }

  @Test
  func `throws malformedXML for invalid XML`() {
    #expect(throws: GPXParseError.malformedXML) {
      try GPXParser.parse(data: Data("not xml".utf8))
    }
  }

  @Test
  func `does not set name from XML`() throws {
    let route = try GPXParser.parse(data: Data(validGPXContent.utf8))
    #expect(route.name == nil)
  }
}

// MARK: - Helpers

private enum TestError: Error { case stub }

private func makeGPXFile(named name: String, content: String) throws -> URL {
  let url = FileManager.default.temporaryDirectory
    .appendingPathComponent(name)
    .appendingPathExtension("gpx")
  try content.write(to: url, atomically: true, encoding: .utf8)
  return url
}

private let validGPXContent = """
<?xml version="1.0"?>
<gpx version="1.1" creator="Test">
  <trk>
    <name>Test Track</name>
    <trkseg>
      <trkpt lat="52.5200" lon="13.4050"/>
      <trkpt lat="52.5210" lon="13.4060"/>
      <trkpt lat="52.5220" lon="13.4070"/>
    </trkseg>
  </trk>
</gpx>
"""

private let emptyTrackGPXContent = """
<?xml version="1.0"?>
<gpx version="1.1">
  <trk><trkseg></trkseg></trk>
</gpx>
"""
