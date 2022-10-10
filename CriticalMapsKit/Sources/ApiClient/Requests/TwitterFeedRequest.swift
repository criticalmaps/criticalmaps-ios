import Foundation
import SharedModels

public extension Request {
  static let twitterFeed = Self(
    endpoint: .twitter,
    httpMethod: .get
  )
}
