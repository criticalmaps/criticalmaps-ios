import Styleguide
import TestHelper
import XCTest

class ErrorStateViewSnapshotTests: XCTestCase {
  func test_ErrorStateView_withoutButton_light() {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      )
    )
    
    assertScreenSnapshot(view)
  }
  
  func test_ErrorStateView_withoutButton_dark() {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      )
    )
      .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view)
  }
  
  func test_ErrorStateView_withButton_light() {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
    
    assertScreenSnapshot(view)
  }
  
  func test_ErrorStateView_withButton_dark() {
    let view = ErrorStateView(
      errorState: .init(
        title: "Critical Maps",
        body: "No mass today"
      ),
      buttonAction: {},
      buttonText: "Reload"
    )
      .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view)
  }
}
