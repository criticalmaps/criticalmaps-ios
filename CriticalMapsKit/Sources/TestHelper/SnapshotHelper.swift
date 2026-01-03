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
    sloppy: Bool = true,
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
            layout: .device(config: .iPhone16),
            traits: .iPhone16(.portrait)
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
    
    var layout = SwiftUISnapshotLayout.device(config: .iPhone16)
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

public extension ViewImageConfig {
  static let iPhone16 = ViewImageConfig.iPhone16(.portrait)
	
  static func iPhone16(_ orientation: Orientation) -> ViewImageConfig {
    let safeArea: UIEdgeInsets
    let size: CGSize
    switch orientation {
    case .landscape:
      safeArea = .init(top: 0, left: 59, bottom: 21, right: 59)
      size = .init(width: 852, height: 393)
    case .portrait:
      safeArea = .init(top: 59, left: 0, bottom: 34, right: 0)
      size = .init(width: 393, height: 852)
    }
    return .init(safeArea: safeArea, size: size, traits: .iPhone16(orientation))
  }
}

public extension UITraitCollection {
  static func iPhone16(_ orientation: ViewImageConfig.Orientation) -> UITraitCollection {
    if #available(iOS 17.0, *) {
      return UITraitCollection(mutations: { mutableTraits in
        mutableTraits.forceTouchCapability = .unavailable
        mutableTraits.layoutDirection = .leftToRight
        mutableTraits.preferredContentSizeCategory = .medium
        mutableTraits.userInterfaceIdiom = .phone
        switch orientation {
        case .landscape:
          mutableTraits.horizontalSizeClass = .compact
          mutableTraits.verticalSizeClass = .compact
        case .portrait:
          mutableTraits.horizontalSizeClass = .compact
          mutableTraits.verticalSizeClass = .regular
        }
      })
    } else {
      let base: [UITraitCollection] = [
        .init(forceTouchCapability: .unavailable),
        .init(layoutDirection: .leftToRight),
        .init(preferredContentSizeCategory: .medium),
        .init(userInterfaceIdiom: .phone)
      ]
      switch orientation {
      case .landscape:
        return .init(
          traitsFrom: base + [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .compact)
          ]
        )
      case .portrait:
        return .init(
          traitsFrom: base + [
            .init(horizontalSizeClass: .compact),
            .init(verticalSizeClass: .regular)
          ]
        )
      }
    }
  }
}
