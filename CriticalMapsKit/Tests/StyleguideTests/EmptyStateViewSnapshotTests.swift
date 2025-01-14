import Styleguide
import TestHelper
import XCTest

final class EmptyStateViewSnapshotTests: XCTestCase {
  func test_emptyStateView_withoutButton_light() {
    let view = EmptyStateView(
      emptyState: .init(
        icon: UIImage(systemName: "bicycle")!,
        text: "Critical Maps"
      )
    )
    
    assertScreenSnapshot(view)
  }
  
  func test_emptyStateView_withoutButton_dark() {
    let view = EmptyStateView(
      emptyState: .init(
        icon: UIImage(systemName: "bicycle")!,
        text: "Critical Maps"
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view)
  }
  
  func test_emptyStateView_withButton_light() {
    let view = EmptyStateView(
      emptyState: .init(
        icon: UIImage(systemName: "bicycle")!,
        text: "Critical Maps",
        message: .init(string: "No mass today")
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    
    assertScreenSnapshot(view)
  }
  
  func test_emptyStateView_withButton_dark() {
    let view = EmptyStateView(
      emptyState: .init(
        icon: UIImage(systemName: "bicycle")!,
        text: "Critical Maps",
        message: .init(string: "No mass today")
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view)
  }
}
