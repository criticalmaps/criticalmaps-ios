import ComposableArchitecture
import Foundation

// MARK: Live

extension FileClient: DependencyKey {
  public static var liveValue: Self {
    let documentDirectory = FileManager.default
      .urls(for: .documentDirectory, in: .userDomainMask)
      .first!
    
    return Self(
      delete: { fileName in
        try? FileManager.default.removeItem(
          at:
            documentDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
        )
      },
      load: { fileName in
        try Data(
          contentsOf:
            documentDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
        )
      },
      save: { fileName, data in
        _ = try? data.write(
          to:
            documentDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
        )
      }
    )
  }
}

extension FileClient: TestDependencyKey {
  public static let testValue: FileClient = Self()
}

let fileExtension = "json"
