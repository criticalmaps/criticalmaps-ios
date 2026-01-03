import SnapshotTesting
import SwiftUI
import XCTest

public enum SnapshotHelper {
  @MainActor
  private static func enforceSnapshotDevice() throws {
    let is2XDevice = UIScreen.main.scale >= 2
    let isMinVersion16 = operatingSystemVersion.majorVersion >= 16
    
    guard is2XDevice, isMinVersion16 else {
      throw SnapshotError.deviceNot2XOrNotIOS16
    }
  }

  @MainActor
  public static func assertScreenSnapshot(
    _ view: some View,
    sloppy: Bool = false,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
  ) throws {
    try enforceSnapshotDevice()
    
    let precision: Float = (sloppy ? .sloppyPrecision : 1)
    
    withSnapshotTesting(diffTool: .ksdiff) {
      assertSnapshots(
        of: view,
        as: [
          .image(
            precision: precision,
            perceptualPrecision: precision,
            layout: .device(config: .iPhone13),
            traits: .iPhone13(.portrait)
          )
        ],
        file: file,
        testName: testName,
        line: line
      )
    }
  }

  @MainActor
  public static func assertViewSnapshot(
    _ view: some View,
    height: CGFloat? = nil,
    width: CGFloat = 375,
    sloppy: Bool = false,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
  ) throws {
    try enforceSnapshotDevice()
    
    var layout = SwiftUISnapshotLayout.device(config: .iPhone8)
    if let height {
      layout = .fixed(width: width, height: height)
    }
    let precision: Float = (sloppy ? .sloppyPrecision : 1)
    
    withSnapshotTesting(diffTool: .ksdiff) {
      assertSnapshot(
        of: view,
        as: .image(precision: precision, layout: layout),
        file: file,
        testName: testName,
        line: line
      )
    }
  }
}

// MARK: - Helper

private extension Float {
  static let sloppyPrecision: Float = 0.95
}

private let operatingSystemVersion = ProcessInfo().operatingSystemVersion

public enum SnapshotError: Error {
  case deviceNot2XOrNotIOS16
}
