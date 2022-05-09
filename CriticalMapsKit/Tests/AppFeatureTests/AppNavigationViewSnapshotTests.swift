import AppFeature
import Foundation
import SnapshotTesting
import TestHelper
import XCTest

class AppNavigationViewSnapshotTests: XCTestCase {
  func test_appNavigationView_light() {
    let view = AppNavigationView(
      store: .init(
        initialState: .init(
          locationsAndChatMessages: nil),
        reducer: appReducer,
        environment: AppEnvironment(
          service: .noop,
          idProvider: .noop,
          mainQueue: .failing,
          locationManager: .failing,
          nextRideService: .noop,
          userDefaultsClient: .noop,
          date: Date.init,
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
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
  
  func test_appNavigationView_dark() {
    let view = AppNavigationView(
      store: .init(
        initialState: .init(
          locationsAndChatMessages: nil),
        reducer: appReducer,
        environment: AppEnvironment(
          service: .noop,
          idProvider: .noop,
          mainQueue: .failing,
          locationManager: .failing,
          nextRideService: .noop,
          userDefaultsClient: .noop,
          date: Date.init,
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_appNavigationView_WithBadge_dark() {
    var appState: AppState = .init(
      locationsAndChatMessages: nil
    )
    appState.chatMessageBadgeCount = 13
    
    let view = AppNavigationView(
      store: .init(
        initialState: appState,
        reducer: appReducer,
        environment: AppEnvironment(
          service: .noop,
          idProvider: .noop,
          mainQueue: .failing,
          locationManager: .failing,
          nextRideService: .noop,
          userDefaultsClient: .noop,
          date: Date.init,
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_appNavigationView_WithBadge() {
    var appState: AppState = .init(
      locationsAndChatMessages: nil
    )
    appState.chatMessageBadgeCount = 13
    
    let view = AppNavigationView(
      store: .init(
        initialState: appState,
        reducer: appReducer,
        environment: AppEnvironment(
          service: .noop,
          idProvider: .noop,
          mainQueue: .failing,
          locationManager: .failing,
          nextRideService: .noop,
          userDefaultsClient: .noop,
          date: Date.init,
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
}
