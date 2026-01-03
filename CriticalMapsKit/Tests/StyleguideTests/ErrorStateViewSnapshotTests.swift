import Foundation
import Styleguide
import TestHelper
import Testing

@MainActor
@Suite("ErrorStateView 📸 Tests", .tags(.snapshot))
struct ErrorStateViewSnapshotTests {
  @Test
  func errorStateView_withoutButton_light() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      )
    )
    
    try SnapshotHelper.assertScreenSnapshot(view)
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
    
    try SnapshotHelper.assertScreenSnapshot(view)
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
    
    try SnapshotHelper.assertScreenSnapshot(view)
  }
}
