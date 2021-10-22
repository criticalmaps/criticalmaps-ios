import Foundation

extension Bundle {
  public var versionNumber: String {
    infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }
  
  public var buildNumber: String {
    infoDictionary?["CFBundleVersion"] as? String ?? ""
  }
}
