import AppFeature
import Foundation
import SnapshotTesting
import TestHelper
import XCTest

@MainActor
final class AppNavigationViewSnapshotTests: XCTestCase {
  func test_appNavigationView_light() {
    let view = AppNavigationView(
      store: .init(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
      )
    )
    
    withSnapshotTesting(diffTool: .ksdiff) {
      assertSnapshots(
        of: view,
        as: [
          .image(precision: 0.9, layout: .device(config: .iPhoneX))
        ],
        file: #file,
        testName: #function,
        line: #line
      )
    }
  }
  
  func test_appNavigationView_dark() {
    let view = AppNavigationView(
      store: .init(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_appNavigationView_WithBadge_dark() {
    var appState = AppFeature.State()
    appState.chatMessageBadgeCount = 13
    
    let view = AppNavigationView(
      store: .init(
        initialState: appState,
        reducer: { AppFeature() }
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_appNavigationView_WithBadge() {
    var appState = AppFeature.State()
    appState.chatMessageBadgeCount = 13
    
    let view = AppNavigationView(
      store: .init(
        initialState: appState,
        reducer: { AppFeature() }
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
}
