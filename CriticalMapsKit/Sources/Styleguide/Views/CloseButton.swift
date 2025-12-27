import ComposableArchitecture
import L10n
import SwiftUI

public struct CloseButton: View {
  let action: () -> Void
  let color: UIColor

  public init(
    color: UIColor = .textPrimary,
    action: @escaping () -> Void
  ) {
    self.color = color
    self.action = action
  }

  public var body: some View {
    Button(
      action: action,
      label: {
        Image(systemName: "xmark")
          .font(.title3)
          .fontWeight(.medium)
          .foregroundStyle(Color(uiColor: color))
      }
    )
    .accessibilityLabel(L10n.Close.Button.label)
  }
}
