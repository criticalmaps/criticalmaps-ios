import Foundation
import UIKit

public struct TextAttributes {
  var textContainerInset: UIEdgeInsets?
  var lineFragmentPadding: CGFloat?
  var returnKeyType: UIReturnKeyType?
  var textAlignment: NSTextAlignment?
  var linkTextAttributes: [NSAttributedString.Key: Any]
  var clearsOnInsertion: Bool?
  var contentType: UITextContentType?
  var autocorrectionType: UITextAutocorrectionType?
  var autocapitalizationType: UITextAutocapitalizationType?
  var lineLimit: Int?
  var lineBreakMode: NSLineBreakMode?
  var isSecure: Bool?
  var isEditable: Bool?
  var isSelectable: Bool?
  var isScrollingEnabled: Bool?
  
  public static var chat: Self {
    .init(
      textContainerInset: .init(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0),
      lineFragmentPadding: 8.0,
      returnKeyType: .none,
      textAlignment: nil,
      linkTextAttributes: [:],
      clearsOnInsertion: false,
      contentType: .none,
      autocorrectionType: .no,
      autocapitalizationType: .some(.none),
      lineLimit: nil,
      lineBreakMode: .byWordWrapping,
      isSecure: false,
      isEditable: true,
      isSelectable: true,
      isScrollingEnabled: true
    )
  }
  
  public static var `default`: Self {
    .init(
      textContainerInset: .init(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0),
      lineFragmentPadding: 8.0,
      returnKeyType: .default,
      textAlignment: nil,
      linkTextAttributes: [:],
      clearsOnInsertion: false,
      contentType: nil,
      autocorrectionType: .default,
      autocapitalizationType: .some(.none),
      lineLimit: nil,
      lineBreakMode: .byWordWrapping,
      isSecure: false,
      isEditable: true,
      isSelectable: true,
      isScrollingEnabled: true
    )
  }
  
  public init(
    textContainerInset: UIEdgeInsets? = nil,
    lineFragmentPadding: CGFloat? = nil,
    returnKeyType: UIReturnKeyType? = nil,
    textAlignment: NSTextAlignment? = nil,
    linkTextAttributes: [NSAttributedString.Key: Any] = [:],
    clearsOnInsertion: Bool? = nil,
    contentType: UITextContentType? = nil,
    autocorrectionType: UITextAutocorrectionType? = nil,
    autocapitalizationType: UITextAutocapitalizationType? = nil,
    lineLimit: Int? = nil,
    lineBreakMode: NSLineBreakMode? = nil,
    isSecure: Bool? = nil,
    isEditable: Bool? = nil,
    isSelectable: Bool? = nil,
    isScrollingEnabled: Bool? = nil
  ) {
    self.textContainerInset = textContainerInset
    self.lineFragmentPadding = lineFragmentPadding
    self.returnKeyType = returnKeyType
    self.textAlignment = textAlignment
    self.linkTextAttributes = linkTextAttributes
    self.clearsOnInsertion = clearsOnInsertion
    self.contentType = contentType
    self.autocorrectionType = autocorrectionType
    self.autocapitalizationType = autocapitalizationType
    self.lineLimit = lineLimit
    self.lineBreakMode = lineBreakMode
    self.isSecure = isSecure
    self.isEditable = isEditable
    self.isSelectable = isSelectable
    self.isScrollingEnabled = isScrollingEnabled
  }
  
  func overriding(_ fallback: Self) -> Self {
    let textContainerInset: UIEdgeInsets? = textContainerInset ?? fallback.textContainerInset
    let lineFragmentPadding: CGFloat? = lineFragmentPadding ?? fallback.lineFragmentPadding
    let returnKeyType: UIReturnKeyType? = returnKeyType ?? fallback.returnKeyType
    let textAlignment: NSTextAlignment? = textAlignment ?? fallback.textAlignment
    let linkTextAttributes: [NSAttributedString.Key: Any] = linkTextAttributes
    let clearsOnInsertion: Bool? = clearsOnInsertion ?? fallback.clearsOnInsertion
    let contentType: UITextContentType? = contentType ?? fallback.contentType
    let autocorrectionType: UITextAutocorrectionType? = autocorrectionType ?? fallback.autocorrectionType
    let autocapitalizationType: UITextAutocapitalizationType? = autocapitalizationType ?? fallback.autocapitalizationType
    let lineLimit: Int? = lineLimit ?? fallback.lineLimit
    let lineBreakMode: NSLineBreakMode? = lineBreakMode ?? fallback.lineBreakMode
    let isSecure: Bool? = isSecure ?? fallback.isSecure
    let isEditable: Bool? = isEditable ?? fallback.isEditable
    let isSelectable: Bool? = isSelectable ?? fallback.isSelectable
    let isScrollingEnabled: Bool? = isScrollingEnabled ?? fallback.isScrollingEnabled
    
    return .init(
      textContainerInset: textContainerInset,
      lineFragmentPadding: lineFragmentPadding,
      returnKeyType: returnKeyType,
      textAlignment: textAlignment,
      linkTextAttributes: linkTextAttributes,
      clearsOnInsertion: clearsOnInsertion,
      contentType: contentType,
      autocorrectionType: autocorrectionType,
      autocapitalizationType: autocapitalizationType,
      lineLimit: lineLimit,
      lineBreakMode: lineBreakMode,
      isSecure: isSecure,
      isEditable: isEditable,
      isSelectable: isSelectable,
      isScrollingEnabled: isScrollingEnabled
    )
  }
}
