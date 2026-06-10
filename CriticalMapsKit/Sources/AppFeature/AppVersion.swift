import Dependencies
import Foundation
import Helpers

/// The app's marketing version (e.g. "4.7.0"), injectable for testability.
///
/// `liveValue` reads `CFBundleShortVersionString`; tests override it to exercise
/// the "What's New" version gating deterministically.
public enum AppVersionKey: DependencyKey {
  public static let liveValue: String = Bundle.main.versionNumber
  public static let testValue = ""
}

public extension DependencyValues {
  var appVersion: String {
    get { self[AppVersionKey.self] }
    set { self[AppVersionKey.self] = newValue }
  }
}
