import AppFeature
import Foundation
import SnapshotTesting
import TestHelper
import Testing

@MainActor
@Suite("AppNavigationView 📸 Tests", .tags(.snapshot))
struct AppNavigationViewSnapshotTests {
  @Test
  func `app navigation view`() throws {
    let view = AppNavigationView(
      store: .init(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
      )
    )
    
    try SnapshotHelper.assertScreenSnapshot(view)
  }
    
  @Test
  func `app navigation view with badge`() throws {
    var appState = AppFeature.State()
    appState.chatMessageBadgeCount = 13
    
    let view = AppNavigationView(
      store: .init(
        initialState: appState,
        reducer: { AppFeature() }
      )
    )
		
    try SnapshotHelper.assertScreenSnapshot(view)
  }
}
