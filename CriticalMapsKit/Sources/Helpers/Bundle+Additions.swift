import Foundation

public extension Bundle {
  var versionNumber: String {
    infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }

  var buildNumber: String {
    infoDictionary?["CFBundleVersion"] as? String ?? ""
  }
}
