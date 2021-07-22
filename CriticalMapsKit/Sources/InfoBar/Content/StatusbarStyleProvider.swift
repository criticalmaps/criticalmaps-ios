import Combine
import Foundation
import UIKit

public struct StatusbarStyleProviderState: Equatable {
  let isPresentingModalSheet: Bool
  let userInterfaceStyle: UIUserInterfaceStyle
  weak var activeViewController: UIViewController?
}

public protocol StatusbarStyleProvider: AnyObject {
  var statusbarStylePublisher: AnyPublisher<
    StatusbarStyleProviderState,
    Never
  > { get }
}
