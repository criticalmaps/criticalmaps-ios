import ComposableArchitecture
import Foundation

/// A Client to dispatch network calls
@DependencyClient
public struct APIClient {
  /// Dispatches a Request and returns its data
  /// - Parameter request: Request to Dispatch
  /// - Returns: The response data of the request
  /// - Throws: A NetworkRquestError if the request fails
  public var send: @Sendable (_ request: Request) async throws -> (Data, URLResponse)
}

extension APIClient: DependencyKey {
  public static var liveValue: APIClient {
    @Dependency(\.networkDispatcher) var networkDispatcher

    return Self { request in
      guard let urlRequest = try? request.makeRequest() else {
        throw NetworkRequestError.badRequest
      }
      return try await networkDispatcher.dispatch(urlRequest)
    }
  }
}

extension APIClient: TestDependencyKey {
  public static var testValue: APIClient = Self()
  public static let previewValue: APIClient = Self(
    send: { _ in (Data(), HTTPURLResponse()) }
  )
}

public extension DependencyValues {
  var apiClient: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}
