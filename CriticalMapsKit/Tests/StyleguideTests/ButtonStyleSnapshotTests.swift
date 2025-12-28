import Styleguide
import SwiftUI
import TestHelper
import XCTest

@MainActor
final class ButtonStylesSnapshotTests: XCTestCase {
  func test_cmButtonStyle() throws {
    let button = Button(
      action: {},
      label: { Text("Critical Maps") }
    )
    .buttonStyle(CMButtonStyle())
    
    try assertViewSnapshot(button, height: 100)
  }
  
  func test_cmButtonStyle_withIcon() throws {
    let button = Button(
      action: {},
      label: {
        HStack {
          Image(systemName: "bicycle")
          Text("Critical Maps")
          Image(systemName: "heart")
        }
      }
    )
    .buttonStyle(CMButtonStyle())
    
    try assertViewSnapshot(button, height: 100)
  }
  
  func test_cmButtonStyle_withIcon2() throws {
    let button = Button(
      action: {},
      label: {
        VStack {
          Image(systemName: "bicycle")
          Text("Critical Maps")
          Image(systemName: "heart")
        }
      }
    )
    .buttonStyle(CMButtonStyle())
    
    try assertViewSnapshot(button, height: 150)
  }
}
