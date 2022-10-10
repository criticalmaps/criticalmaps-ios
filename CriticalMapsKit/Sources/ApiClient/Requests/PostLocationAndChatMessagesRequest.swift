import Foundation
import SharedModels

public extension Request {
  static func locationsAndChats(body: Data?) -> Self {
    Self(
      endpoint: .criticalmaps,
      httpMethod: .post,
      body: body
    )
  }
}
