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

public extension Guide {
  enum Rule: String, CaseIterable {
    case brake
    case contraflow
    case gently
    case green
    case haveFun
    case stayLoose

    var title: String {
      switch self {
      case .brake:
        L10n.Rules.Title.brake
      case .contraflow:
        L10n.Rules.Title.contraflow
      case .gently:
        L10n.Rules.Title.gently
      case .green:
        L10n.Rules.Title.green
      case .haveFun:
        L10n.Rules.Title.haveFun
      case .stayLoose:
        L10n.Rules.Title.stayLoose
      }
    }

    var text: String {
      switch self {
      case .brake:
        L10n.Rules.Text.brake
      case .contraflow:
        L10n.Rules.Text.contraflow
      case .gently:
        L10n.Rules.Text.gently
      case .green:
        L10n.Rules.Text.green
      case .haveFun:
        L10n.Rules.Text.haveFun
      case .stayLoose:
        L10n.Rules.Text.stayLoose
      }
    }

    var image: UIImage {
      switch self {
      case .brake:
        Asset.brake.image
      case .contraflow:
        Asset.wrongLane.image
      case .gently:
        Asset.slowly.image
      case .green:
        Asset.green.image
      case .haveFun:
        Asset.pose.image
      case .stayLoose:
        Asset.friendly.image
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
