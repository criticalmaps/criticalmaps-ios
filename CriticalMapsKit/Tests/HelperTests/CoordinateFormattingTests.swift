import SharedModels
import Testing

@Suite
struct CoordinateFormattingTests {
  @Test("Format positive coordinates (Northern/Eastern hemisphere)")
  func formatPositiveCoordinates() {
    // given - Berlin coordinates
    let berlin = Coordinate(latitude: 52.524657, longitude: 13.413939)

    // when
    let formatted = berlin.formattedForCopying

    // then
    #expect(formatted == "52.52466° N, 13.41394° E")
  }

  @Test("Format negative longitude (Western hemisphere)")
  func formatNegativeLongitude() {
    // given - San Francisco coordinates
    let sanFrancisco = Coordinate(latitude: 37.774929, longitude: -122.419416)

    // when
    let formatted = sanFrancisco.formattedForCopying

    // then
    #expect(formatted == "37.77493° N, 122.41942° W")
  }

  @Test("Format negative latitude (Southern hemisphere)")
  func formatNegativeLatitude() {
    // given - Melbourne coordinates
    let melbourne = Coordinate(latitude: -37.813628, longitude: 144.963058)

    // when
    let formatted = melbourne.formattedForCopying

    // then
    #expect(formatted == "37.81363° S, 144.96306° E")
  }

  @Test("Format both negative coordinates (Southern/Western hemisphere)")
  func formatBothNegativeCoordinates() {
    // given - Santiago, Chile coordinates
    let santiago = Coordinate(latitude: -33.448457, longitude: -70.669265)

    // when
    let formatted = santiago.formattedForCopying

    // then
    #expect(formatted == "33.44846° S, 70.66926° W")
  }

  @Test("Format coordinates at equator and prime meridian")
  func formatZeroCoordinates() {
    // given - Null Island (0,0)
    let nullIsland = Coordinate(latitude: 0.0, longitude: 0.0)

    // when
    let formatted = nullIsland.formattedForCopying

    // then
    #expect(formatted == "0.00000° N, 0.00000° E")
  }

  @Test("Format coordinates with small decimal values")
  func formatSmallDecimalValues() {
    // given - very precise coordinates
    let precise = Coordinate(latitude: 0.000001, longitude: -0.000001)

    // when
    let formatted = precise.formattedForCopying

    // then
    #expect(formatted == "0.00000° N, 0.00000° W")
  }

  @Test("Format coordinates using existing test data - Alexander Platz")
  func formatAlexanderPlatz() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz

    // when
    let formatted = alexanderPlatz.formattedForCopying

    // then
    #expect(formatted == "52.52466° N, 13.41394° E")
  }

  @Test("Format coordinates using existing test data - Rendsburg")
  func formatRendsburg() {
    // given
    let rendsburg = Coordinate.TestData.rendsburg

    // when
    let formatted = rendsburg.formattedForCopying

    // then
    #expect(formatted == "54.30855° N, 9.65664° E")
  }

  @Test("Verify decimal precision is exactly 5 places")
  func verifyDecimalPrecision() {
    // given - coordinate with many decimal places
    let manyDecimals = Coordinate(latitude: 52.12345678901234, longitude: 13.98765432109876)

    // when
    let formatted = manyDecimals.formattedForCopying

    // then
    #expect(formatted == "52.12346° N, 13.98765° E")

    // Verify the format matches the expected pattern
    let components = formatted.components(separatedBy: ", ")
    #expect(components.count == 2)

    // Check latitude part
    let latPart = components[0]
    #expect(latPart.hasSuffix("° N"))
    let latValue = latPart.replacingOccurrences(of: "° N", with: "")
    let latDecimalPlaces = latValue.components(separatedBy: ".")[1].count
    #expect(latDecimalPlaces == 5)

    // Check longitude part
    let lngPart = components[1]
    #expect(lngPart.hasSuffix("° E"))
    let lngValue = lngPart.replacingOccurrences(of: "° E", with: "")
    let lngDecimalPlaces = lngValue.components(separatedBy: ".")[1].count
    #expect(lngDecimalPlaces == 5)
  }

  @Test("Format coordinates at maximum valid latitude")
  func formatMaxLatitude() {
    // given - maximum valid latitude (90°)
    let maxLat = Coordinate(latitude: 90.0, longitude: 0.0)

    // when
    let formatted = maxLat.formattedForCopying

    // then
    #expect(formatted == "90.00000° N, 0.00000° E")
  }

  @Test("Format coordinates at minimum valid latitude")
  func formatMinLatitude() {
    // given - minimum valid latitude (-90°)
    let minLat = Coordinate(latitude: -90.0, longitude: 0.0)

    // when
    let formatted = minLat.formattedForCopying

    // then
    #expect(formatted == "90.00000° S, 0.00000° E")
  }

  @Test("Format coordinates at maximum valid longitude")
  func formatMaxLongitude() {
    // given - maximum valid longitude (180°)
    let maxLng = Coordinate(latitude: 0.0, longitude: 180.0)

    // when
    let formatted = maxLng.formattedForCopying

    // then
    #expect(formatted == "0.00000° N, 180.00000° E")
  }

  @Test("Format coordinates at minimum valid longitude")
  func formatMinLongitude() {
    // given - minimum valid longitude (-180°)
    let minLng = Coordinate(latitude: 0.0, longitude: -180.0)

    // when
    let formatted = minLng.formattedForCopying

    // then
    #expect(formatted == "0.00000° N, 180.00000° W")
  }
}

extension Coordinate {
  enum TestData {
    static let rendsburg = Coordinate(latitude: 54.308547, longitude: 9.656645)
    static let alexanderPlatz = Coordinate(latitude: 52.524657, longitude: 13.413939)
  }
}
