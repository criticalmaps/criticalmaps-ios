import Foundation

/// A client to dispatch network request to URLSession
public struct NetworkDispatcher {
  var dispatch: @Sendable (URLRequest) async throws -> (Data, URLResponse)

  public init(
    dispatch: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse)
  ) {
    self.dispatch = dispatch
  }
}

extension NetworkDispatcher {
  /// Parses a HTTP StatusCode and returns a proper error
  /// - Parameter statusCode: HTTP status code
  /// - Returns: Mapped Error
  private static func httpError(_ statusCode: Int) -> NetworkRequestError {
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
      return .decodingError
    case let urlError as URLError:
      return .urlSessionFailed(urlError)
    case let error as NetworkRequestError:
      return error
    default:
      return .unknownError
    }
  }
}

public extension NetworkDispatcher {
  static func live(urlSession: URLSession = .shared) -> Self {
    Self { urlRequest in
      let (data, response) = try await urlSession.data(for: urlRequest)
      if let response = response as? HTTPURLResponse, !response.isSuccessful {
        throw httpError(response.statusCode)
      }
      return (data, response)
    }
  }

  static let noop = Self { _ in fatalError() }
}

extension HTTPURLResponse {
  /// Indicates that the client's request was successfully received, understood, and accepted
  var isSuccessful: Bool {
    (200 ... 299).contains(statusCode)
  }
}
