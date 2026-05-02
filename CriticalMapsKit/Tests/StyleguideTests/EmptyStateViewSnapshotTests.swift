import Foundation
import Styleguide
import TestHelper
import Testing

@MainActor
@Suite("EmptyStateView 📸 Tests", .tags(.snapshot))
struct EmptyStateViewSnapshotTests {
  @Test
  func `empty state view without button light`() throws {
    let view = EmptyStateView(
      emptyState: .init(
        icon: Asset.chatEmpty.image,
        text: "Critical Maps"
      )
    )
    
    try SnapshotHelper.assertScreenSnapshot(view)
  }
  
  @Test
  func `empty state view with button light`() throws {
    let view = EmptyStateView(
      emptyState: .init(
        icon: Asset.chatEmpty.image,
        text: "Critical Maps",
        message: AttributedString("No mass today")
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    
    try SnapshotHelper.assertScreenSnapshot(view)
  }
}
