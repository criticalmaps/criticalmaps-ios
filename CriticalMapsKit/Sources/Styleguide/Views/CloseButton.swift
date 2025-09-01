import ComposableArchitecture
import L10n
import SwiftUI

public struct CloseButton: View {
  let action: () -> Void
  
  public init(action: @escaping () -> Void) {
    self.action = action
  }
  
  public var body: some View {
    Button(
      action: action,
      label: {
        Image(systemName: "xmark")
          .font(Font.system(size: 22, weight: .medium))
          .foregroundColor(Color(.textPrimary))
      }
    )
    .accessibilityLabel(L10n.Close.Button.label)
  }
}
