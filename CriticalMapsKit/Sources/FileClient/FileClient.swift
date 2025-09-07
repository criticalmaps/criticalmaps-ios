import Combine
import ComposableArchitecture
import Foundation
import Helpers
import SharedModels

// MARK: Interface

/// Client handling FileManager interactions
@DependencyClient
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

  public func save(
    _ data: some Encodable,
    to fileName: String,
    with encoder: JSONEncoder = JSONEncoder()
  ) async throws {
    let data = try data.encoded(encoder: encoder)
    try await save(fileName, data)
  }
}

// Convenience methods for UserSettings handling
public extension FileClient {
  func loadUserSettings() async throws -> UserSettings {
    try await load(UserSettings.self, from: userSettingsFileName)
  }

  func saveUserSettings(userSettings: UserSettings) async throws {
    try await save(userSettings, to: userSettingsFileName)
  }
}

// MARK: - DependencyValue

public extension DependencyValues {
  var fileClient: FileClient {
    get { self[FileClient.self] }
    set { self[FileClient.self] = newValue }
  }
}

// MARK: Helper

let userSettingsFileName = "user-settings"
