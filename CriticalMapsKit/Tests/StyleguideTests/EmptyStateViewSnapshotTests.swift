import Foundation
import Styleguide
import TestHelper
import Testing

@MainActor
@Suite("EmptyStateView  📸 Tests", .tags(.snapshot))
struct EmptyStateViewSnapshotTests {
  @Test
  func emptyStateView_withoutButton_light() throws {
    let view = EmptyStateView(
      emptyState: .init(
        icon: Asset.chatEmpty.image,
        text: "Critical Maps"
      )
    ).environment(\.colorScheme, .light)
    
    try assertScreenSnapshot(view)
  }
  
  @Test
  func emptyStateView_withoutButton_dark() throws {
    let view = EmptyStateView(
      emptyState: .init(
        icon: Asset.chatEmpty.image,
        text: "Critical Maps"
      )
    )
    .environment(\.colorScheme, .dark)
    
    try assertScreenSnapshot(view)
  }
  
  @Test
  func emptyStateView_withButton_light() throws {
    let view = EmptyStateView(
      emptyState: .init(
        icon: Asset.chatEmpty.image,
        text: "Critical Maps",
        message: AttributedString("No mass today")
      ),
      buttonAction: {},
      buttonText: "Reload"
    ).environment(\.colorScheme, .light)
    
    try assertScreenSnapshot(view)
  }
  
  @Test
  func emptyStateView_withButton_dark() throws {
    let view = EmptyStateView(
      emptyState: .init(
        icon: Asset.chatEmpty.image,
        text: "Critical Maps",
        message: AttributedString("No mass today")
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    .environment(\.colorScheme, .dark)
    
    try assertScreenSnapshot(view)
  }
}
