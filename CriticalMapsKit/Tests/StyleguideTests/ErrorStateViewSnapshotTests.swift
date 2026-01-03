import Foundation
import Styleguide
import TestHelper
import Testing

@MainActor
@Suite("ErrorStateView  📸 Tests", .tags(.snapshot))
struct ErrorStateViewSnapshotTests {
  @Test
  func errorStateView_withoutButton_light() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      )
    )
    
    try assertScreenSnapshot(view, sloppy: true)
  }
  
  @Test
  func errorStateView_withoutButton_dark() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      )
    )
    .environment(\.colorScheme, .dark)
    
    try assertScreenSnapshot(view, sloppy: true)
  }
  
  @Test
  func errorStateView_withButton_light() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    
    try assertScreenSnapshot(view, sloppy: true)
  }
  
  @Test
  func errorStateView_withButton_dark() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    .environment(\.colorScheme, .dark)
    
    try assertScreenSnapshot(view, sloppy: true)
  }
}
