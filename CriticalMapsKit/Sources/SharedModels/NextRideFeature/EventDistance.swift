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
    Measurement<UnitLength>(value: Double(rawValue), unit: .kilometers)
  }

  public var displayValue: String {
    let formatter = MeasurementFormatter.distanceFormatter
    formatter.unitStyle = .short
    return formatter.string(from: length)
  }

  public var accessibilityLabel: String {
    let formatter = MeasurementFormatter.distanceFormatter
    formatter.unitStyle = .long
    return formatter.string(from: length)
  }
}

extension MeasurementFormatter {
  static let distanceFormatter: MeasurementFormatter = {
    let formatter = MeasurementFormatter()
    formatter.unitOptions = [.providedUnit]
    return formatter
  }()
}
