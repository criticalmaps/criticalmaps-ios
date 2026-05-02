import Foundation
import Helpers
import Testing

struct CodableExtensionsTests {
  let testModel = [1, 2, 3]

  @Test
  func `Encoding Helper Function`() throws {
    let testModelEncoded = try testModel.encoded()

    let testData = try JSONEncoder().encode(testModel)
    #expect(testModelEncoded == testData)
  }

  @Test
  func `Decoding Helper Function`() throws {
    let encodedTestModel = try JSONEncoder().encode(testModel)
    let decodedTestModed: [Int] = try encodedTestModel.decoded()

    #expect(decodedTestModed == testModel)
  }
}
