import Combine
import ComposableArchitecture
import Foundation
import Helpers
import SharedModels

// MARK: Interface
public struct FileClient {
  public var delete: (String) -> Effect<Never, Error>
  public var load: (String) -> Effect<Data, Error>
  public var save: (String, Data) -> Effect<Never, Error>
  
  public func load<A: Decodable>(
    _ type: A.Type, from fileName: String
  ) -> Effect<Result<A, NSError>, Never> {
    self.load(fileName)
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
extension FileClient {
  public func loadUserSettings() -> Effect<Result<UserSettings, NSError>, Never> {
    self.load(UserSettings.self, from: userSettingsFileName)
  }

  public func saveUserSettings(
    userSettings: UserSettings, on queue: AnySchedulerOf<DispatchQueue>
  ) -> Effect<Never, Never> {
    self.save(userSettings, to: userSettingsFileName, on: queue)
  }
}

public let userSettingsFileName = "user-settings"


// MARK: Live
extension FileClient {
  public static var live: Self {
    let documentDirectory = FileManager.default
      .urls(for: .documentDirectory, in: .userDomainMask)
      .first!

    return Self(
      delete: { fileName in
        .fireAndForget {
          try? FileManager.default.removeItem(
            at:
              documentDirectory
              .appendingPathComponent(fileName)
              .appendingPathExtension("json")
          )
        }
      },
      load: { fileName in
        .catching {
          try Data(
            contentsOf:
              documentDirectory
              .appendingPathComponent(fileName)
              .appendingPathExtension("json")
          )
        }
      },
      save: { fileName, data in
        .fireAndForget {
          _ = try? data.write(
            to:
              documentDirectory
              .appendingPathComponent(fileName)
              .appendingPathExtension("json")
          )
        }
      }
    )
  }
}

// MARK: Mocks
extension FileClient {
  public static let noop = Self(
    delete: { _ in .none },
    load: { _ in .none },
    save: { _, _ in .none }
  )
}
