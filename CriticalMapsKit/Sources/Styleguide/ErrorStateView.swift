import L10n
import SwiftUI
import SwiftUIHelpers

public struct ErrorState: Equatable {
  public let title: String
  public let body: String?
  public let error: NSError?

  public init(title: String, body: String?, error: NSError? = nil) {
    self.title = title
    self.body = body
    self.error = error
  }
}

public extension ErrorState {
  static let `default` = Self(
    title: L10n.ErrorState.title,
    body: L10n.ErrorState.message
  )
}

public struct ErrorStateView: View {
  public let errorState: ErrorState
  public var buttonAction: (() -> Void)?
  public var buttonText: String?

  public init(
    errorState: ErrorState,
    buttonAction: (() -> Void)? = nil,
    buttonText: String? = nil
  ) {
    self.errorState = errorState
    self.buttonAction = buttonAction
    self.buttonText = buttonText
  }

  public var body: some View {
    ZStack {
      Color(.backgroundPrimary)
        .ignoresSafeArea()

      VStack(spacing: .grid(5)) {
        Image(uiImage: Asset.error.image)
          .frame(maxWidth: .infinity)
          .accessibilityHidden(true)

        VStack(spacing: .grid(2)) {
          Text(errorState.title)
            .font(.titleOne)
            .foregroundColor(Color(.textPrimary))
          if let message = errorState.body {
            Text(message)
              .font(.bodyOne)
              .foregroundColor(Color(.textSecondary))
          }
          if buttonAction != nil {
            Button(
              action: buttonAction ?? {},
              label: { Text(buttonText ?? "") }
            )
            .buttonStyle(CMButtonStyle())
            .padding(.top, .grid(4))
          }
        }
      }
    }
    .frame(maxHeight: .infinity, alignment: .center)
  }
}

struct ErrorStateView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      ErrorStateView(errorState: .default)
    }
  }
}
