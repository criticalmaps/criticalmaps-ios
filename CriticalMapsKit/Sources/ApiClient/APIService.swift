import Foundation
import SharedModels

// MARK: Interface

/// A Service to send and fetch locations and chat messages from the Criticl Maps API
public struct APIService {
  public var getRiders: @Sendable () async throws -> [Rider]
  public var postRiderLocation: @Sendable (SendLocationPostBody) async throws -> ApiResponse
  public var getChatMessages: @Sendable () async throws -> [ChatMessage]
  public var postChatMessage: @Sendable (ChatMessagePost) async throws -> ApiResponse

  public init(
    postRiderLocation: @Sendable @escaping (SendLocationPostBody) async throws -> ApiResponse,
    getRiders: @Sendable @escaping () async throws -> [Rider],
    getChatMessages: @Sendable @escaping () async throws -> [ChatMessage],
    postChatMessage: @Sendable @escaping (ChatMessagePost) async throws -> ApiResponse
  ) {
    self.postRiderLocation = postRiderLocation
    self.getRiders = getRiders
    self.getChatMessages = getChatMessages
    self.postChatMessage = postChatMessage
  }
}

// MARK: Live

public extension APIService {
  static func live(apiClient: APIClient = .live()) -> Self {
    Self(
      postRiderLocation: { body in
        let request: Request = .put(.locations, body: try? body.encoded())
        let (data, _) = try await apiClient.send(request)
        return try data.decoded()
      },
      getRiders: {
        let request: Request = .get(.locations)
        let (data, _) = try await apiClient.send(request)
        return try data.decoded()
      },
      getChatMessages: {
        let request: Request = .get(.chatMessages)
        let (data, _) = try await apiClient.send(request)
        return try data.decoded()
      },
      postChatMessage: { body in
        let request: Request = .post(.chatMessages, body: try? body.encoded())
        let (data, _) = try await apiClient.send(request)
        return try data.decoded()
      }
    )
  }
}

// MARK: Mocks and failing used for previews and tests

public extension APIService {
  static let noop = Self(
    postRiderLocation: { _ in
      ApiResponse(status: "ok")
    },
    getRiders: { [] },
    getChatMessages: { [] },
    postChatMessage: { _ in
      ApiResponse(status: "ok")
    }
  )

  static let failing = Self(
    postRiderLocation: { _ in throw NSError(domain: "", code: 1) },
    getRiders: { throw NSError(domain: "", code: 1) },
    getChatMessages: { throw NSError(domain: "", code: 1) },
    postChatMessage: { _ in throw NSError(domain: "", code: 1) }
  )
}

public struct ApiResponse: Codable, Equatable {
  public init(status: String?) {
    self.status = status
  }
  
  public var status: String?
}
