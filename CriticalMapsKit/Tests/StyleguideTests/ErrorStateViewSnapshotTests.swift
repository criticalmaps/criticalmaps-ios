import Styleguide
import TestHelper
import XCTest

@MainActor
final class ErrorStateViewSnapshotTests: XCTestCase {
  func test_ErrorStateView_withoutButton_light() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      )
    )
    
    try assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_ErrorStateView_withoutButton_dark() throws {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      )
    )
    .environment(\.colorScheme, .dark)
    
    try assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_ErrorStateView_withButton_light() throws {
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
  
  func test_ErrorStateView_withButton_dark() throws {
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
