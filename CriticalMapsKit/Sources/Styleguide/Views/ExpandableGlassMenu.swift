import SwiftUI

@available(iOS 26, *)
public struct ExpandableGlassMenu<Content: View, Label: View>: View, Animatable {
  public var alignment: Alignment
  public var progress: CGFloat
  public var labelSize: CGSize = .init(width: 52, height: 52)
  public var cornerRadius: CGFloat = 24
  @ViewBuilder var content: () -> Content
  @ViewBuilder var label: () -> Label
  /// View Properties
  @State private var contentSize: CGSize = .zero
  
  public var animatableData: CGFloat {
    get { progress }
    set { progress = newValue }
  }
  
  public init(
    alignment: Alignment,
    progress: CGFloat,
    labelSize: CGSize = .init(width: 50, height: 50),
    contentSize: CGSize = .zero,
    @ViewBuilder content: @escaping () -> Content,
    @ViewBuilder label: @escaping () -> Label
  ) {
    self.alignment = alignment
    self.progress = progress
    self.labelSize = labelSize
    self.content = content
    self.label = label
    self.contentSize = contentSize
  }
  
  public var body: some View {
    GlassEffectContainer {
      let widthDiff = contentSize.width - labelSize.width
      let heightDiff = contentSize.height - labelSize.height
      
      let rWidth = widthDiff * contentOpacity
      let rHeight = heightDiff * contentOpacity
      
      ZStack(alignment: alignment) {
        content()
          .compositingGroup()
          .scaleEffect(contentScale)
          .blur(radius: 14 * blurProgress)
          .opacity(contentOpacity)
          .onGeometryChange(for: CGSize.self) {
            $0.size
          } action: { newValue in
            contentSize = newValue
          }
          .fixedSize()
          .frame(
            width: labelSize.width + rWidth,
            height: labelSize.height + rHeight
          )
        
        label()
          .compositingGroup()
          .blur(radius: 14 * blurProgress)
          .opacity(1 - labelOpacity)
          .frame(width: labelSize.width, height: labelSize.height)
      }
      .compositingGroup()
      .clipShape(.rect(cornerRadius: cornerRadius))
      .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
    }
    .scaleEffect(
      x: 1 - (blurProgress * 0.35),
      y: 1 + (blurProgress * 0.45),
      anchor: scaleAnchor
    )
    .offset(y: offset * blurProgress)
  }
  
  private var labelOpacity: CGFloat {
    min(progress / 0.35, 1)
  }
  
  private var contentOpacity: CGFloat {
    max(progress - 0.35, 0) / 0.65
  }
  
  private var contentScale: CGFloat {
    let minAspectScale = min(labelSize.width / contentSize.width, labelSize.height / contentSize.height)
    
    return minAspectScale + (1 - minAspectScale) * progress
  }
  
  private var blurProgress: CGFloat {
    /// 0 -> 0.5 -> 0
    progress > 0.5 ? (1 - progress) / 0.5 : progress / 0.5
  }
  
  private var offset: CGFloat {
    switch alignment {
    case .bottom, .bottomLeading, .bottomTrailing: -50
    case .top, .topLeading, .topTrailing: 50
    /// Center!
    default: 0
    }
  }
  
  /// Converting Alignment into UnitPoint for ScaleEffect
  private var scaleAnchor: UnitPoint {
    switch alignment {
    case .bottomLeading: .bottomLeading
    case .bottom: .bottom
    case .bottomTrailing: .bottomTrailing
    case .topLeading: .topLeading
    case .top: .top
    case .topTrailing: .topTrailing
    case .leading: .leading
    case .trailing: .trailing
    default: .center
    }
  }
}
