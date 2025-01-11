import CoreLocation
import NextRideFeature
import SharedModels
import Testing

struct CoordinateObfuscatorTests {
  var sut: CoordinateObfuscator = .liveValue
  
  @Test("Obuscator should return coordinate with altered thirdDecimal")
  func alteredCoordinate() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .thirdDecimal)
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
  
  @Test("Obuscator should return coordinate with altered firstDecimal")
  func firstDecimal() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .firstDecimal)
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
  
  @Test("Obuscator should return coordinate with alteredThirdDecimal")
  func thirdDecimal() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .thirdDecimal)
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
  
  @Test("Obuscator should return coordinate with alteredFourthDecimal")
  func fourthDecimal() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .fourthDecimal)
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
  
  @Test("Obfuscator should return coordinate with custom range")
  func customRange() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(
      alexanderPlatz,
      .custom(0.0000004 ... 0.0004)
    )
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
}
