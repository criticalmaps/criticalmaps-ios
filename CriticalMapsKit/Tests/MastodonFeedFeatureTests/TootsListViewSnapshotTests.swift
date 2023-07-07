import MastodonKit
import SharedModels
import SnapshotTesting
import TestHelper
import TwitterFeedFeature
import XCTest

final class TootsListViewSnapshotTests: XCTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
//      isRecording = true
  }
    
  func test_tootListViewSnapshot() {
    let view = TootsListView(
      store: .init(
        initialState: .init(toots: .init(uniqueElements: [Status].placeHolder)),
        reducer: TootFeedFeature()
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tootListViewSnapshot_dark() {
    let view = TootsListView(
      store: .init(
        initialState: .init(toots: .init(uniqueElements: [Status].placeHolder)),
        reducer: TootFeedFeature()
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tootListViewSnapshot_redacted() {
    let view = TootsListView(
      store: .init(
        initialState: .init(toots: .init(uniqueElements: [Status].placeHolder)),
        reducer: TootFeedFeature()
      )
    )
    .redacted(reason: .placeholder)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tootListViewSnapshot_redacted_dark() {
    let view = TootsListView(
      store: .init(
        initialState: .init(toots: .init(uniqueElements: [Status].placeHolder)),
        reducer: TootFeedFeature()
      )
    )
    .redacted(reason: .placeholder)
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tootListViewSnapshot_empty() {
    let view = TootsListView(
      store: .init(
        initialState: .init(toots: .init(uniqueElements: [Status].placeHolder)),
        reducer: TootFeedFeature()
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tootListViewSnapshot_empty_dark() {
    let view = TootsListView(
      store: .init(
        initialState: .init(toots: .init(uniqueElements: [Status].placeHolder)),
        reducer: TootFeedFeature()
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tootListViewSnapshot_error() {
    let view = TootsListView(
      store: .init(
        initialState: .init(toots: .init(uniqueElements: [Status].placeHolder)),
        reducer: TootFeedFeature()
      )
    )
    
    assertScreenSnapshot(view, sloppy: true)
  }
  
  func test_tootListViewSnapshot_error_dark() {
    let view = TootsListView(
      store: .init(
        initialState: .init(toots: .init(uniqueElements: [Status].placeHolder)),
        reducer: TootFeedFeature()
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(view, sloppy: true)
  }
}
