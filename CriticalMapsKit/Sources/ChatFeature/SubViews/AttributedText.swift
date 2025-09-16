import SwiftUI

// MARK: - AttributedText

struct AttributedText: View {
  @Environment(\.textAttributes)
  var envTextAttributes: TextAttributes
  
  @Binding var attributedText: NSAttributedString
  @Binding var isEditing: Bool
  
  @State private var sizeThatFits: CGSize = .zero
  
  private let textAttributes: TextAttributes
  
  private let onLinkInteraction: ((URL) -> Bool)?
  private let onEditingChanged: ((Bool) -> Void)?
  private let onCommit: (() -> Void)?
  
  var body: some View {
    let textAttributes = textAttributes
      .overriding(envTextAttributes)
      .overriding(TextAttributes.default)
    
    return GeometryReader { geometry in
      UITextViewWrapper(
        attributedText: $attributedText,
        isEditing: $isEditing,
        sizeThatFits: $sizeThatFits,
        maxSize: geometry.size,
        textAttributes: textAttributes,
        onLinkInteraction: onLinkInteraction,
        onEditingChanged: onEditingChanged,
        onCommit: onCommit
      )
      .preference(
        key: ContentSizeThatFitsKey.self,
        value: sizeThatFits
      )
    }
  }
  
  init(
    attributedText: Binding<NSAttributedString>,
    isEditing: Binding<Bool>,
    textAttributes: TextAttributes = .init(),
    onLinkInteraction: ((URL) -> Bool)? = nil,
    onEditingChanged: ((Bool) -> Void)? = nil,
    onCommit: (() -> Void)? = nil
  ) {
    _attributedText = attributedText
    _isEditing = isEditing
    
    self.textAttributes = textAttributes
    
    self.onLinkInteraction = onLinkInteraction
    self.onEditingChanged = onEditingChanged
    self.onCommit = onCommit
  }
}
