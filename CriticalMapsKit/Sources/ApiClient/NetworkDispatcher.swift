import ComposableArchitecture
import Foundation

/// A client to dispatch network request to URLSession
@DependencyClient
public struct NetworkDispatcher: Sendable {
  var dispatch: @Sendable (URLRequest) async throws -> (Data, URLResponse)
}

extension NetworkDispatcher {
  /// Parses a HTTP StatusCode and returns a proper error
  /// - Parameter statusCode: HTTP status code
  /// - Returns: Mapped Error
  private static func httpError(_ statusCode: Int?) -> NetworkRequestError {
    guard let statusCode else { return .unknownError }
    switch statusCode {
    case 400: return .badRequest
    case 403: return .forbidden
    case 404: return .notFound
    case 402, 405 ... 499: return .error4xx(statusCode)
    case 500: return .serverError
    case 501 ... 599: return .error5xx(statusCode)
    default: return .unknownError
    }
  }

  /// Parses URLSession Publisher errors and return proper ones
  /// - Parameter error: URLSession publisher error
  /// - Returns: Readable NetworkRequestError
  private static func handleError(_ error: Error) -> NetworkRequestError {
    switch error {
    case is Swift.DecodingError:
      .decodingError
    case let urlError as URLError:
      .urlSessionFailed(urlError)
    case let error as NetworkRequestError:
      error
    default:
      .unknownError
    }
  }
}

extension NetworkDispatcher: DependencyKey {
  public static var liveValue: NetworkDispatcher {
    @Dependency(\.urlSession) var urlSession

    return Self { urlRequest in
      let (data, response) = try await urlSession.data(for: urlRequest)
      @Shared(.hasConnectionError) var hasConnectionError

      guard let response = response as? HTTPURLResponse else {
        $hasConnectionError.withLock { $0 = true }
        throw NetworkRequestError.invalidResponse
      }
      $hasConnectionError.withLock { $0 = false }

      // check for connection failure reasons
      guard !NSURLErrorConnectionFailureCodes.contains(response.statusCode) else {
        throw NetworkRequestError.connectionLost
      }

      // check if response is successful
      guard response.isSuccessful else {
        throw httpError(response.statusCode)
      }
      return (data, response)
    }
  }
}

extension HTTPURLResponse {
  /// Indicates that the client's request was successfully received, understood, and accepted
  var isSuccessful: Bool {
    (200 ... 299).contains(statusCode)
  }
}

let NSURLErrorConnectionFailureCodes: [Int] = [
  NSURLErrorCannotFindHost, /// Error Code: ` -1003`
  NSURLErrorCannotConnectToHost, /// Error Code: ` -1004`
  NSURLErrorNetworkConnectionLost, /// Error Code: ` -1005`
  NSURLErrorNotConnectedToInternet, /// Error Code: ` -1009`
  NSURLErrorSecureConnectionFailed /// Error Code: ` -1200`
]

extension DependencyValues {
  var networkDispatcher: NetworkDispatcher {
    get { self[NetworkDispatcher.self] }
    set { self[NetworkDispatcher.self] = newValue }
  }
}

public extension SharedReaderKey where Self == InMemoryKey<Bool>.Default {
  static var hasConnectionError: Self {
    Self[.inMemory("hasConnectionError"), default: false]
  }
}
