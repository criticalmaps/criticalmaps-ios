import SwiftUI

/// A view that wraps UIVisualEffectView
public struct Blur: UIViewRepresentable {
  var style: UIBlurEffect.Style = .systemMaterial

  public init(style: UIBlurEffect.Style = .systemMaterial) {
    self.style = style
  }
    
  public func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }
  
  public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
