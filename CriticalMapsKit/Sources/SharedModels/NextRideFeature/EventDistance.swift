import Foundation

/// Enum to represent event distance in kilometer
public enum EventDistance: Int, CaseIterable, Codable, Sendable {
  /// 5 km
  case close = 5
  /// 10 km
  case near = 10
  /// 20 km
  case far = 20

  var length: Measurement<UnitLength> {
    Measurement<UnitLength>(
      value: Double(rawValue),
      unit: .kilometers
    )
  }

  public var displayValue: String {
    // Abbreviated width: e.g., "5 km"
    length.formatted(
      .measurement(
        width: .abbreviated,
        usage: .road,
        numberFormatStyle: .number
      )
    )
  }

  public var accessibilityLabel: String {
    // Wide width: e.g., "5 kilometers"
    length.formatted(
      .measurement(
        width: .wide,
        usage: .road,
        numberFormatStyle: .number
      )
    )
  }
}
