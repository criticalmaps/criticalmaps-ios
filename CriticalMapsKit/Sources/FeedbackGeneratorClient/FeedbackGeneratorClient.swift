import ComposableArchitecture
import DependenciesMacros
import Foundation
import UIKit

@DependencyClient
public struct FeedbackGeneratorClient {
  public var prepare: @Sendable () async -> Void
  public var selectionChanged: @Sendable () async -> Void
}

extension FeedbackGeneratorClient: DependencyKey {
  public static let liveValue = {
    let generator = UISelectionFeedbackGenerator()
    return Self(
      prepare: { generator.prepare() },
      selectionChanged: { generator.selectionChanged() }
    )
  }()
}

extension FeedbackGeneratorClient: TestDependencyKey {
  public static let previewValue = Self.noop
  public static let testValue = Self()
}

extension FeedbackGeneratorClient {
  public static let noop = Self(
    prepare: {},
    selectionChanged: {}
  )
}

extension DependencyValues {
  public var feedbackGenerator: FeedbackGeneratorClient {
    get { self[FeedbackGeneratorClient.self] }
    set { self[FeedbackGeneratorClient.self] = newValue }
  }
}
