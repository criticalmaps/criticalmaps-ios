import Foundation

/// A Client to dispatch network calls
public struct APIClient {
  var networkDispatcher: NetworkDispatcher

  public init(networkDispatcher: NetworkDispatcher) {
    self.networkDispatcher = networkDispatcher
  }
  
  /// Dispatches a Request and returns its data
  /// - Parameter request: Request to Dispatch
  /// - Returns: The response data of the request
  /// - Throws: A NetworkRquestError if the request fails
  public func dispatch<R: APIRequest>(_ request: R) async throws -> Data {
    guard let urlRequest = try? request.makeRequest() else {
      throw NetworkRequestError.badRequest
    }
    return try await networkDispatcher
      .dispatch(request: urlRequest)
  }
}

public extension APIClient {
  static let live = Self(networkDispatcher: .live)
  static let noop = Self(networkDispatcher: .noop)
}
