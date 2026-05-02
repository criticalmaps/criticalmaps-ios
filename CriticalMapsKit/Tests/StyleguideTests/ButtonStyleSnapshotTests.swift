import Styleguide
import SwiftUI
import TestHelper
import Testing

@MainActor
@Suite("ButtonStyles  📸 Tests", .tags(.snapshot))
struct ButtonStylesSnapshotTests {
  @Test
  func `cm button style`() throws {
    let button = Button(
      action: {},
      label: { Text("Critical Maps") }
    )
    .buttonStyle(CMButtonStyle())
    
    try SnapshotHelper.assertViewSnapshot(button, height: 100)
  }
  
  @Test
  func `cm button style with icon`() throws {
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
    
    try SnapshotHelper.assertViewSnapshot(button, height: 100)
  }
  
  @Test
  func `cm button style with icon 2`() throws {
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
    
    try SnapshotHelper.assertViewSnapshot(button, height: 150)
  }
}
