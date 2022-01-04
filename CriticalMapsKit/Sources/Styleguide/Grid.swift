import CoreGraphics

public extension CGFloat {
  /// A function which describes the styleguides grid. The grids multiply factor is 4
  /// - Parameter n: Factor to multipliy by the grids multiply factor
  /// - Returns: The calculated number
  static func grid(_ n: Int) -> Self { Self(n) * 4 }
}
