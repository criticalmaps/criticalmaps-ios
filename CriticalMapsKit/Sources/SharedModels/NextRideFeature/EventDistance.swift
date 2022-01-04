import Foundation

/// Enum to represent event distance in kilometer
public enum EventDistance: Int, CaseIterable, Codable {
  /// 5 km
  case close = 5
  /// 10 km
  case near = 10
  /// 20 km
  case far = 20
  
  public var displayValue: String {
    "\(self.rawValue) km"
  }
  
  public var accessibilityLabel: String {
    "\(self.rawValue) kilometer"
  }
}
