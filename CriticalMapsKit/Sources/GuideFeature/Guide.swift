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
        return Asset.brake.image
      case .contraflow:
        return Asset.wrongLane.image
      case .cork:
        return Asset.corken.image
      case .gently:
        return Asset.slowly.image
      case .green:
        return Asset.green.image
      case .haveFun:
        return Asset.pose.image
      case .stayLoose:
        return Asset.friendly.image
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
