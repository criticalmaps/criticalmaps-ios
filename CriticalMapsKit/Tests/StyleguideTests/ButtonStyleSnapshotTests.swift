import Styleguide
import SwiftUI
import TestHelper
import XCTest

class ButtonStylesSnapshotTests: XCTestCase {
  func test_cmButtonStyle() {
    let button = Button(
      action: {},
      label: { Text("Critical Maps") }
    )
    .buttonStyle(CMButtonStyle())
    
    assertViewSnapshot(button, height: 100)
  }
  
  func test_cmButtonStyle_withIcon() {
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
    
    assertViewSnapshot(button, height: 100)
  }
  
  func test_cmButtonStyle_withIcon2() {
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
    
    assertViewSnapshot(button, height: 150)
  }
}
