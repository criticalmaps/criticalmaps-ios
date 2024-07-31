import AppFeature
import Foundation
import SnapshotTesting
import TestHelper
import XCTest

final class AppNavigationViewSnapshotTests: XCTestCase {
  @MainActor
  func test_appNavigationView_light() {
    let view = AppNavigationView(
      store: .init(
        initialState: .init(locationsAndChatMessages: nil),
        reducer: { AppFeature() }
      )
    )
    
    assertSnapshots(
      matching: view,
      as: [
        .image(precision: 0.9, layout: .device(config: .iPhoneX))
      ],
      file: #file,
      testName: #function,
      line: #line
    )
  }
  
  @MainActor
  func test_appNavigationView_dark() {
    let view = AppNavigationView(
      store: .init(
        initialState: .init(locationsAndChatMessages: nil),
        reducer: { AppFeature() }
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  @MainActor
  func test_appNavigationView_WithBadge_dark() {
    var appState: AppFeature.State = .init(
      locationsAndChatMessages: nil
    )
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
  
  @MainActor
  func test_appNavigationView_WithBadge() {
    var appState: AppFeature.State = .init(
      locationsAndChatMessages: nil
    )
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
