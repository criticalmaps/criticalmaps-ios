import SnapshotTesting
import SwiftUI
import XCTest

private let operatingSystemVersion = ProcessInfo().operatingSystemVersion

public extension XCTestCase {
  private func enforceSnapshotDevice() {
    let is2XDevice = UIScreen.main.scale >= 2
    let isMinVersion14 = operatingSystemVersion.majorVersion >= 14
    
    guard is2XDevice, isMinVersion14 else {
      fatalError("Screenshot test device should use @2x screen scale and iOS 14.4")
    }
  }
  
  private static let sloppyPrecision: Float = 0.9
  
  func assertScreenSnapshot<V: View>(
    _ view: V,
    sloppy: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
  ) {
    enforceSnapshotDevice()
    
    let precision: Float = (sloppy ? XCTestCase.sloppyPrecision : 1)
    assertSnapshots(
      matching: view,
      as: [
        .image(precision: precision, layout: .device(config: .iPhone8)),
        .image(precision: precision, layout: .device(config: .iPhoneXsMax)),
        .image(precision: precision, layout: .device(config: .iPhoneSe)),
        .image(precision: precision, layout: .device(config: .iPadPro11))
      ],
      file: file,
      testName: testName,
      line: line
    )
  }
  
  func assertViewSnapshot<V: View>(
    _ view: V,
    height: CGFloat? = nil,
    sloppy: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
  ) {
    enforceSnapshotDevice()
    
    var layout = SwiftUISnapshotLayout.device(config: .iPhone8)
    if let height = height {
      layout = .fixed(width: 375, height: height)
    }
    let precision: Float = (sloppy ? XCTestCase.sloppyPrecision : 1)
    
    assertSnapshot(
      matching: view,
      as: .image(precision: precision, layout: layout),
      file: file,
      testName: testName,
      line: line
    )
  }
}
