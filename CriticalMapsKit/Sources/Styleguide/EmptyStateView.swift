import SwiftUI
import L10n

public struct EmptyState: Equatable {
  public let icon: UIImage
  public let text: String
  public var message: String?

  public init(icon: UIImage, text: String, message: String? = nil) {
    self.icon = icon
    self.text = text
    self.message = message
  }
}

public extension EmptyState {
  static let twitter = Self(
    icon: Images.twitterEmpty,
    text: L10n.Twitter.noData,
    message: "Here you’ll find tweets tagged with @criticalmaps and #criticalmass"
  )
}

public struct EmptyStateView: View {
  public let emptyState: EmptyState

  public init(emptyState: EmptyState) {
    self.emptyState = emptyState
  }
  
  public var body: some View {
    ZStack {
      Color(.backgroundPrimary)
        .ignoresSafeArea()
      
      VStack(spacing: .grid(5)) {
        Image(uiImage: emptyState.icon)
          .imageScale(.large)
        VStack(spacing: .grid(2)) {
          Text(emptyState.text)
            .font(.titleOne)
          if let message = emptyState.message {
            Text(message)
              .multilineTextAlignment(.center)
              .font(.bodyOne)
              .foregroundColor(Color(.textSecondary))
          }
        }
        .padding(.horizontal, .grid(4))
      }
      .frame(maxHeight: .infinity, alignment: .center)
      .foregroundColor(Color(.textPrimary))
    }
  }
}

struct EmptyStateView_Previews: PreviewProvider {
  static var previews: some View {
    EmptyStateView(emptyState: .twitter)
  }
}
