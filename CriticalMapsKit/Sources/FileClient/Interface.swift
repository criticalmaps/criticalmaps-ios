import Combine
import ComposableArchitecture
import Foundation
import Helpers
import SharedModels

// MARK: Interface

/// Client handling FileManager interactions
public struct FileClient {
  public var delete: (String) -> Effect<Never, Error>
  public var load: (String) -> Effect<Data, Error>
  public var save: (String, Data) -> Effect<Never, Error>

  public func load<A: Decodable>(
    _ type: A.Type, from fileName: String
  ) -> Effect<Result<A, NSError>, Never> {
    load(fileName)
      .decode(type: A.self, decoder: JSONDecoder())
      .mapError { $0 as NSError }
      .catchToEffect()
  }

  public func save<A: Encodable>(
    _ data: A, to fileName: String, on queue: AnySchedulerOf<DispatchQueue>
  ) -> Effect<Never, Never> {
    Just(data)
      .subscribe(on: queue)
      .encode(encoder: JSONEncoder())
      .flatMap { data in self.save(fileName, data) }
      .ignoreFailure()
      .eraseToEffect()
  }
}

// Convenience methods for UserSettings handling
public extension FileClient {
  func loadUserSettings() -> Effect<Result<UserSettings, NSError>, Never> {
    load(UserSettings.self, from: userSettingsFileName)
  }

  func saveUserSettings(
    userSettings: UserSettings, on queue: AnySchedulerOf<DispatchQueue>
  ) -> Effect<Never, Never> {
    save(userSettings, to: userSettingsFileName, on: queue)
  }
}

public let userSettingsFileName = "user-settings"
