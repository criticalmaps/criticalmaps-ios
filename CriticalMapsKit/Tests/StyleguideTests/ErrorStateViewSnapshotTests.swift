import Foundation
import Styleguide
import TestHelper
import Testing

@MainActor
@Suite("ErrorStateView 📸 Tests", .tags(.snapshot))
struct ErrorStateViewSnapshotTests {
  @Test
  func `error state view without button light`() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      )
    )
    
    try SnapshotHelper.assertScreenSnapshot(view)
  }
  
  @Test
  func `error state view with button light`() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    
    try SnapshotHelper.assertScreenSnapshot(view)
  }
  
  @Test
  func `error state view with button dark`() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    
    try SnapshotHelper.assertScreenSnapshot(view)
  }
}
