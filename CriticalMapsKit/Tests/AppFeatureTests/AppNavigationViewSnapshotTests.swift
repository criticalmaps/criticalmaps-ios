import AppFeature
import Foundation
import SnapshotTesting
import TestHelper
import Testing

@MainActor
@Suite("AppNavigationView  📸 Tests", .tags(.snapshot))
struct AppNavigationViewSnapshotTests {
  @Test
  func appNavigationView_light() {
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
  
  @Test
  func appNavigationView_dark() throws {
    let view = AppNavigationView(
      store: .init(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
      )
    )
    .environment(\.colorScheme, .dark)
    
    try SnapshotHelper.assertScreenSnapshot(view, sloppy: true)
  }
  
  @Test
  func appNavigationView_WithBadge_dark() throws {
    var appState = AppFeature.State()
    appState.chatMessageBadgeCount = 13
    
    let view = AppNavigationView(
      store: .init(
        initialState: appState,
        reducer: { AppFeature() }
      )
    )
    .environment(\.colorScheme, .dark)
    
    try SnapshotHelper.assertScreenSnapshot(view, sloppy: true)
  }
  
  @Test
  func appNavigationView_WithBadge() throws {
    var appState = AppFeature.State()
    appState.chatMessageBadgeCount = 13
    
    let view = AppNavigationView(
      store: .init(
        initialState: appState,
        reducer: { AppFeature() }
      )
    )
    
    try SnapshotHelper.assertScreenSnapshot(view, sloppy: true)
  }
}
