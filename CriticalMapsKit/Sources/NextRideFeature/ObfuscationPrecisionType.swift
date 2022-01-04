import Foundation

/// A type that represents the decimal precision distance for the coordinate obfuscation
public enum ObfuscationPrecisionType {
  /// is worth up to 11.1 km
  case firstDecimal
  /// is worth up to 1.1 km
  case secondDecimal
  /// is worth up to 110 m
  case thirdDecimal
  /// is worth up to 11 m
  case fourthDecimal
  case custom(ClosedRange<Double>)
  
  public var randomInRange: Double {
    Double.random(in: range)
  }
  
  private var range: ClosedRange<Double> {
    switch self {
    case .firstDecimal, .secondDecimal, .thirdDecimal, .fourthDecimal:
      let lowerBound: Double = -9
      let upperBound: Double = 9
      return (lowerBound / decimalFactor ... upperBound / decimalFactor)
    case let .custom(customRange): return customRange
    }
  }
  
  private var decimalFactor: Double {
    switch self {
    case .firstDecimal: return 10
    case .secondDecimal: return 100
    case .thirdDecimal: return 1000
    case .fourthDecimal: return 10000
    case .custom: return 1
    }
  }
}
