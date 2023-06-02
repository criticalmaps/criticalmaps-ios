import SharedModels
import SwiftUI

public struct ChatMessageView: View {
  public init(_ chat: ChatMessage) {
    self.chat = chat
  }

  var chatTime: String {
    Date(timeIntervalSince1970: chat.timestamp)
      .formatted(Date.FormatStyle.chatTime())
  }
  
  let chat: ChatMessage

  public var body: some View {
    VStack(alignment: .leading, spacing: .grid(1)) {
      Text(chatTime)
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
        identifier: "id",
        device: "device",
        message: "Hello World!",
        timestamp: .pi
      )
    )
  }
}
