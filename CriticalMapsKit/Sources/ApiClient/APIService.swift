import ComposableArchitecture
import Foundation
import SharedModels

// MARK: Interface

/// A Service to send and fetch locations and chat messages from the Critical Maps API
@DependencyClient
public struct APIService {
  public var getRiders: @Sendable () async throws -> [Rider]
  public var postRiderLocation: @Sendable (SendLocationPostBody) async throws -> ApiResponse
  public var getChatMessages: @Sendable () async throws -> [ChatMessage]
  public var postChatMessage: @Sendable (ChatMessagePost) async throws -> ApiResponse
}

// MARK: Live

extension APIService: DependencyKey {
  public static var liveValue: APIService {
    @Dependency(\.apiClient) var apiClient

    return Self(
      getRiders: {
        let request: Request = .get(.locations)
        let (data, _) = try await apiClient.send(request)
        return try data.decoded()
      }, 
      postRiderLocation: { body in
        let request: Request = .put(.locations, body: try? body.encoded())
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

// MARK: Test and Preview Values

extension APIService: TestDependencyKey {
  public static let testValue: APIService = Self()
  public static let previewValue: APIService = Self(
    getRiders: { [] },
    postRiderLocation: { _ in
      ApiResponse(status: "ok")
    },
    getChatMessages: { [] },
    postChatMessage: { _ in
      ApiResponse(status: "ok")
    }
  )
}

public extension DependencyValues {
  var apiService: APIService {
    get { self[APIService.self] }
    set { self[APIService.self] = newValue }
  }
}

public struct ApiResponse: Codable, Equatable {
  public init(status: String?) {
    self.status = status
  }

  public var status: String?
}
