import Foundation
import SwiftUI

struct UITextViewWrapper: UIViewRepresentable {
  typealias UIViewType = UITextView
  
  @Environment(\.textAttributes)
  var envTextAttributes: TextAttributes
  
  @Binding var attributedText: NSAttributedString
  @Binding var isEditing: Bool
  @Binding var sizeThatFits: CGSize
  
  private let maxSize: CGSize
  
  private let textAttributes: TextAttributes
  
  private let onLinkInteraction: ((URL) -> Bool)?
  private let onEditingChanged: ((Bool) -> Void)?
  private let onCommit: (() -> Void)?
  
  init(
    attributedText: Binding<NSAttributedString>,
    isEditing: Binding<Bool>,
    sizeThatFits: Binding<CGSize>,
    maxSize: CGSize,
    textAttributes: TextAttributes = .init(),
    onLinkInteraction: ((URL) -> Bool)? = nil,
    onEditingChanged: ((Bool) -> Void)? = nil,
    onCommit: (() -> Void)? = nil
  ) {
    _attributedText = attributedText
    _isEditing = isEditing
    _sizeThatFits = sizeThatFits
    
    self.maxSize = maxSize
    
    self.textAttributes = textAttributes
    
    self.onLinkInteraction = onLinkInteraction
    self.onEditingChanged = onEditingChanged
    self.onCommit = onCommit
  }
  
  func makeUIView(context: Context) -> UITextView {
    let view = UITextView()
    
    view.delegate = context.coordinator
    
    view.font = UIFont.preferredFont(forTextStyle: .body)
    view.textColor = UIColor.label
    view.backgroundColor = .clear
    
    let attrs = textAttributes
    
    if let textContainerInset = attrs.textContainerInset {
      view.textContainerInset = textContainerInset
    }
    if let lineFragmentPadding = attrs.lineFragmentPadding {
      view.textContainer.lineFragmentPadding = lineFragmentPadding
    }
    if let returnKeyType = attrs.returnKeyType {
      view.returnKeyType = returnKeyType
    }
    if let textAlignment = attrs.textAlignment {
      view.textAlignment = textAlignment
    }
    view.linkTextAttributes = attrs.linkTextAttributes
    view.linkTextAttributes = attrs.linkTextAttributes
    if let clearsOnInsertion = attrs.clearsOnInsertion {
      view.clearsOnInsertion = clearsOnInsertion
    }
    if let contentType = attrs.contentType {
      view.textContentType = contentType
    }
    if let autocorrectionType = attrs.autocorrectionType {
      view.autocorrectionType = autocorrectionType
    }
    if let autocapitalizationType = attrs.autocapitalizationType {
      view.autocapitalizationType = autocapitalizationType
    }
    if let isSecure = attrs.isSecure {
      view.isSecureTextEntry = isSecure
    }
    if let isEditable = attrs.isEditable {
      view.isEditable = isEditable
    }
    if let isSelectable = attrs.isSelectable {
      view.isSelectable = isSelectable
    }
    if let isScrollingEnabled = attrs.isScrollingEnabled {
      view.isScrollEnabled = isScrollingEnabled
    }
    if let lineLimit = attrs.lineLimit {
      view.textContainer.maximumNumberOfLines = lineLimit
    }
    if let lineBreakMode = attrs.lineBreakMode {
      view.textContainer.lineBreakMode = lineBreakMode
    }
    
    view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    return view
  }
  
  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.attributedText = attributedText
    if isEditing {
      uiView.becomeFirstResponder()
    } else {
      uiView.resignFirstResponder()
    }
    UITextViewWrapper.recalculateHeight(
      view: uiView,
      maxContentSize: maxSize,
      result: $sizeThatFits
    )
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(
      attributedText: $attributedText,
      isEditing: $isEditing,
      sizeThatFits: $sizeThatFits,
      maxContentSize: { maxSize },
      onLinkInteraction: onLinkInteraction,
      onEditingChanged: onEditingChanged,
      onCommit: onCommit
    )
  }
  
  static func recalculateHeight(
    view: UIView,
    maxContentSize: CGSize,
    result: Binding<CGSize>
  ) {
    let sizeThatFits = view.sizeThatFits(maxContentSize)
    if result.wrappedValue != sizeThatFits {
      DispatchQueue.main.async {
        // Must be called asynchronously:
        result.wrappedValue = sizeThatFits
      }
    }
  }
  
  final class Coordinator: NSObject, UITextViewDelegate {
    @Binding var attributedText: NSAttributedString
    @Binding var isEditing: Bool
    @Binding var sizeThatFits: CGSize
    
    private let maxContentSize: () -> CGSize
    
    private var onLinkInteraction: ((URL) -> Bool)?
    private var onEditingChanged: ((Bool) -> Void)?
    private var onCommit: (() -> Void)?
    
    init(
      attributedText: Binding<NSAttributedString>,
      isEditing: Binding<Bool>,
      sizeThatFits: Binding<CGSize>,
      maxContentSize: @escaping () -> CGSize,
      onLinkInteraction: ((URL) -> Bool)?,
      onEditingChanged: ((Bool) -> Void)?,
      onCommit: (() -> Void)?
    ) {
      _attributedText = attributedText
      _isEditing = isEditing
      _sizeThatFits = sizeThatFits
      
      self.maxContentSize = maxContentSize
      
      self.onLinkInteraction = onLinkInteraction
      self.onEditingChanged = onEditingChanged
      self.onCommit = onCommit
    }
    
    func textViewDidChange(_ uiView: UITextView) {
      attributedText = uiView.attributedText
      onEditingChanged?(true)
      UITextViewWrapper.recalculateHeight(
        view: uiView,
        maxContentSize: maxContentSize(),
        result: $sizeThatFits
      )
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      DispatchQueue.main.async {
        guard !self.isEditing else {
          return
        }
        self.isEditing = true
      }
      
      onEditingChanged?(false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
      DispatchQueue.main.async {
        guard self.isEditing else {
          return
        }
        self.isEditing = false
      }
      
      onCommit?()
    }
    
    func textView(
      _ textView: UITextView,
      shouldInteractWith url: URL,
      in characterRange: NSRange
    ) -> Bool {
      onLinkInteraction?(url) ?? true
    }
    
    func textView(
      _ textView: UITextView,
      shouldChangeTextIn range: NSRange,
      replacementText text: String
    ) -> Bool {
      guard let onCommit, text == "\n" else {
        return true
      }
      
      textView.resignFirstResponder()
      onCommit()
      
      return false
    }
  }
}
