import UIKit

public class PassthroughWindow: UIWindow {
  var passthroughTag = 15123393
  
  public override var tag: Int {
    get { passthroughTag }
    set { passthroughTag = newValue }
  }
  
  override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let result = super.hitTest(point, with: event),
          result.tag != passthroughTag
    else {
      return nil
    }
    
    return result
  }
}
