import Foundation

public extension Encodable {
  func encoded(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
    try encoder.encode(self)
  }
}

public extension Data {
  func decoded<T: Decodable>(decoder: JSONDecoder = JSONDecoder()) throws -> T {
    try decoder.decode(T.self, from: self)
  }
}
