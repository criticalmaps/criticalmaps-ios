import SwiftUI
import L10n

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
  let errorState: ErrorState

  public init(errorState: ErrorState) {
    self.errorState = errorState
  }
  
  public var body: some View {
    ZStack {
      Color(.backgroundPrimary)
        .ignoresSafeArea()
      
      VStack(spacing: .grid(5)) {
        Image(uiImage: Images.errorPlaceholder)
          .frame(maxWidth: .infinity)
        VStack(spacing: .grid(2)) {
          Text(errorState.title)
            .font(.titleOne)
            .foregroundColor(Color(.textPrimary))
          if let message = errorState.body {
            Text(message)
              .font(.bodyOne)
              .foregroundColor(Color(.textSecondary))
          }
        }
      }
    }
    .frame(maxHeight: .infinity, alignment: .center)
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    ErrorStateView(errorState: .default)
  }
}
