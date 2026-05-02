import CoreLocation
import NextRideFeature
import SharedModels
import Testing

struct CoordinateObfuscatorTests {
  var sut: CoordinateObfuscator = .liveValue
  
  @Test
  func `Obuscator should return coordinate with altered thirdDecimal`() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .thirdDecimal)
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
  
  @Test
  func `Obuscator should return coordinate with altered firstDecimal`() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .firstDecimal)
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
  
  @Test
  func `Obuscator should return coordinate with alteredThirdDecimal`() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .thirdDecimal)
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
  
  @Test
  func `Obuscator should return coordinate with alteredFourthDecimal`() {
    // given
    let alexanderPlatz = Coordinate.TestData.alexanderPlatz
    // when
    let alteredCoordinate = sut.obfuscate(alexanderPlatz, .fourthDecimal)
    // then
    #expect(alexanderPlatz != alteredCoordinate)
  }
  
  @Test
  func `Obfuscator should return coordinate with custom range`() {
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
