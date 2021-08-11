import ComposableArchitecture
import Foundation
import L10n
import Styleguide
import UIKit.UIImage

public struct Guide: Hashable, Identifiable {
  public let id: String
  public let rule: Rule
  
  public init(id: String = UUID().uuidString, rule: Guide.Rule) {
    self.id = id
    self.rule = rule
  }
}

extension Guide {
  public enum Rule: String, CaseIterable {
    case brake
    case contraflow
    case cork
    case gently
    case green
    case haveFun
    case stayLoose
    
    var title: String {
      switch self {
      case .brake:
        return L10n.Rules.Title.brake
      case .contraflow:
        return L10n.Rules.Title.contraflow
      case .cork:
        return L10n.Rules.Title.cork
      case .gently:
        return L10n.Rules.Title.gently
      case .green:
        return L10n.Rules.Title.green
      case .haveFun:
        return L10n.Rules.Title.haveFun
      case .stayLoose:
        return L10n.Rules.Title.stayLoose
      }
    }
    
    var text: String {
      switch self {
      case .brake:
        return L10n.Rules.Text.brake
      case .contraflow:
        return L10n.Rules.Text.contraflow
      case .cork:
        return L10n.Rules.Text.cork
      case .gently:
        return L10n.Rules.Text.gently
      case .green:
        return L10n.Rules.Text.green
      case .haveFun:
        return L10n.Rules.Text.haveFun
      case .stayLoose:
        return L10n.Rules.Text.stayLoose
      }
    }
    
    var image: UIImage {
      switch self {
      case .brake:
        return Images.brake
      case .contraflow:
        return Images.contraflow
      case .cork:
        return Images.corken
      case .gently:
        return Images.gently
      case .green:
        return Images.green
      case .haveFun:
        return Images.havefun
      case .stayLoose:
        return Images.stayloose
      }
    }
  }
}

public extension Guide {
  static let all: [Guide] =
    Guide.Rule.allCases.map {
      Guide(rule: $0)
    }
}
