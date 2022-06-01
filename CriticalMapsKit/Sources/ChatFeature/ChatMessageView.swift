import SwiftUI

public struct ChatMessageView: View {
  public init(_ chat: IdentifiedChatMessage) {
    self.chat = chat
  }

  let chat: IdentifiedChatMessage

  public var body: some View {
    VStack(alignment: .leading, spacing: .grid(1)) {
      Text(chat.chatTime)
        .foregroundColor(Color(.textPrimary))
        .font(.meta)
      Text(chat.message)
        .foregroundColor(Color(.textSecondary))
        .font(.bodyOne)
    }
  }
}

struct ChatMessageView_Previews: PreviewProvider {
  static var previews: some View {
    ChatMessageView(
      .init(
        id: "",
        message: "Hello World!",
        timestamp: .pi
      )
    )
  }
}
