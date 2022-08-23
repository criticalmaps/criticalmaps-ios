import Foundation
import SharedModels

// Interface
/// A Service to send and fetch locations and chat messages from the Criticl Maps API
public struct LocationsAndChatDataService {
  public var getLocationsAndSendMessages: (SendLocationAndChatMessagesPostBody) async throws -> LocationAndChatMessages
  
  public init(getLocationsAndSendMessages: @escaping (SendLocationAndChatMessagesPostBody) async throws -> LocationAndChatMessages) {
    self.getLocationsAndSendMessages = getLocationsAndSendMessages
  }
}

// MARK: Live

public extension LocationsAndChatDataService {
  static func live(
    apiClient: APIClient = .live
  ) -> Self {
    Self(
      getLocationsAndSendMessages: { body in
        let request = PostLocationAndChatMessagesRequest(body: try? body.encoded())

        let data = try await apiClient.dispatch(request)
        return try request.decode(data)
      }
    )
  }
}

// MARK: Mocks and failing used for previews and tests

public extension LocationsAndChatDataService {
  static let noop = Self(
    getLocationsAndSendMessages: { _ in LocationAndChatMessages(locations: [:], chatMessages: [:]) }
  )

  static let failing = Self(
    getLocationsAndSendMessages: { _ in
      throw NSError(domain: "", code: 1)
    }
  )
}
