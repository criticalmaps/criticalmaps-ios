import SwiftUI

struct SizeRelativeOffsetEffect: GeometryEffect {
  private var offsetMutiplier: CGPoint
  
  init(offsetMutiplier: CGPoint) {
    self.offsetMutiplier = offsetMutiplier
  }
  
  var animatableData: AnimatablePair<CGFloat, CGFloat> {
    get {
      AnimatablePair(
        offsetMutiplier.x,
        offsetMutiplier.y
      )
    }
    set {
      offsetMutiplier = CGPoint(x: newValue.first, y: newValue.second)
    }
  }
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    return ProjectionTransform(
      CGAffineTransform(
        translationX: size.width * offsetMutiplier.x,
        y: size.height * offsetMutiplier.y
      )
    )
  }
}
