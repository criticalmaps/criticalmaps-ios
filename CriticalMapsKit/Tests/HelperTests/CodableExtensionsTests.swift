import Foundation
import Helpers
import Testing

@Suite
struct CodableExtensionsTests {
  let testModel = [1, 2, 3]

  @Test("Encoding Helper Function")
  func encodedHelperFunctionShouldEncode() throws {
    let testModelEncoded = try testModel.encoded()

    let testData = try JSONEncoder().encode(testModel)
    #expect(testModelEncoded == testData)
  }

  @Test("Decoding Helper Function")
  func decodedHelperFunctionShouldDecode() throws {
    let encodedTestModel = try JSONEncoder().encode(testModel)
    let decodedTestModed: [Int] = try encodedTestModel.decoded()

    #expect(decodedTestModed == testModel)
  }
}
