import Combine
import ComposableArchitecture
import Foundation
import Helpers
import SharedModels

// MARK: Interface

/// Client handling FileManager interactions
public struct FileClient {
  public var delete: @Sendable (String) async throws -> Void
  public var load: @Sendable (String) async throws -> Data
  public var save: @Sendable (String, Data) async throws -> Void
  
  public func load<A: Decodable>(
    _ type: A.Type,
    from fileName: String,
    with decoder: JSONDecoder = JSONDecoder()
  ) async throws -> A {
    let data = try await load(fileName)
    return try data.decoded(decoder: decoder)
  }
  
  public func save<A: Encodable>(
    _ data: A,
    to fileName: String,
    with encoder: JSONEncoder = JSONEncoder()
  ) async {
    Task(priority: .background) {
      let data = try data.encoded(encoder: encoder)
      try await self.save(fileName, data)
    }
  }
}


// Convenience methods for UserSettings handling
public extension FileClient {
  func loadUserSettings() async throws -> UserSettings {
    try await load(UserSettings.self, from: userSettingsFileName)
  }

  func saveUserSettings(userSettings: UserSettings) async {
    await self.save(userSettings, to: userSettingsFileName)
  }
}

let userSettingsFileName = "user-settings"
