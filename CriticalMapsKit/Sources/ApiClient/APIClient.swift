import Foundation

/// A Client to dispatch network calls
public struct APIClient {
  /// Dispatches a Request and returns its data
  /// - Parameter request: Request to Dispatch
  /// - Returns: The response data of the request
  /// - Throws: A NetworkRquestError if the request fails
  public var request: @Sendable (any APIRequest) async throws -> (Data, URLResponse)

  public init(
    request: @escaping @Sendable (any APIRequest) async throws -> (Data, URLResponse)
  ) {
    self.request = request
  }
}

public extension APIClient {
  static func live(networkDispatcher: NetworkDispatcher = .live()) -> Self {
    Self { request in
      guard let urlRequest = try? request.makeRequest() else {
        throw NetworkRequestError.badRequest
      }
      return try await networkDispatcher.dispatch(urlRequest)
    }
  }
  static let noop = Self(request: { _ in fatalError() })
}
