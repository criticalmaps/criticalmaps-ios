import L10n
import SwiftUI
import SwiftUIHelpers

public struct EmptyState: Equatable, Sendable {
  public let icon: UIImage
  public let text: String
  public var message: AttributedString?

  public init(
    icon: UIImage,
    text: String,
    message: AttributedString? = nil
  ) {
    self.icon = icon
    self.text = text
    self.message = message
  }
}

public struct EmptyStateView: View {
  public init(
    emptyState: EmptyState,
    buttonAction: (() -> Void)? = nil,
    buttonText: String? = nil
  ) {
    self.emptyState = emptyState
    self.buttonAction = buttonAction
    self.buttonText = buttonText
  }

  public let emptyState: EmptyState
  public var buttonAction: (() -> Void)?
  public var buttonText: String?

  public var body: some View {
    ZStack {
      Color.backgroundPrimary
        .ignoresSafeArea()

      VStack(spacing: .grid(5)) {
        Image(uiImage: emptyState.icon)
          .imageScale(.large)
          .foregroundStyle(Color.textPrimary)
          .accessibilityHidden(true)

        VStack(spacing: .grid(2)) {
          Text(emptyState.text)
            .font(.titleOne)
          if let message = emptyState.message {
            Text(message)
              .multilineTextAlignment(.center)
              .font(.bodyOne)
              .foregroundColor(.textSecondary)
          }
          if buttonAction != nil {
            Button(
              action: buttonAction ?? {},
              label: { Text(buttonText ?? "") }
            )
            .buttonStyle(CMButtonStyle())
            .padding(.top, .grid(4))
            .accessibilitySortPriority(1)
          }
        }
        .padding(.horizontal, .grid(4))
      }
      .accessibilityElement(children: .contain)
      .frame(maxHeight: .infinity, alignment: .center)
      .foregroundColor(.textPrimary)
    }
  }
}

#Preview {
  EmptyStateView(
    emptyState: EmptyState(
      icon: Asset.toot.image,
      text: "No toots atm",
      message: AttributedString("")
    )
  )
}
