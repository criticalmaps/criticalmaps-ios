import Foundation
import SharedModels

public struct TwitterFeedRequest: APIRequest {
  public typealias ResponseDataType = TwitterFeed

  public var queryItems: [URLQueryItem]
  public var body: Data?
  public var endpoint: Endpoint
  public var headers: HTTPHeaders?
  public var httpMethod: HTTPMethod

  public init(
    queryItems: [URLQueryItem] = [],
    body: Data? = nil,
    endpoint: Endpoint = .twitter,
    headers: HTTPHeaders? = nil,
    httpMethod: HTTPMethod = .get
  ) {
    self.queryItems = queryItems
    self.body = body
    self.endpoint = endpoint
    self.headers = headers
    self.httpMethod = httpMethod
  }

  public let decoder: JSONDecoder = .twitterFeedDecoder
}

private extension DateFormatter {
  static let twitterDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    return formatter
  }()
}

extension JSONDecoder {
  static let twitterFeedDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.twitterDateFormatter)
    return decoder
  }()
}
