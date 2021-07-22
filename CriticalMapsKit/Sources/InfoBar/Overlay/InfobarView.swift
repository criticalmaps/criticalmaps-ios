import Helpers
import SwiftUI
import Styleguide

public struct InfobarView: View {
  @Environment(\.colorScheme) var colorScheme
  private let infobar: Infobar
  
  public init(_ infobar: Infobar) {
    self.infobar = infobar
  }
  
  public var body: some View {
    HStack(
      alignment: .center,
      spacing: .grid(2),
      content: {
        icon
        VStack(alignment: .leading, spacing: .grid(2)) {
          Text(infobar.trimmedMessage)
            .lineLimit(2)
            .font(.system(.body))
          if let subTitle = infobar.subTitle {
            Text(subTitle)
              .lineLimit(2)
              .font(.system(.body))
          }
        }
        Spacer(minLength: 0)
      }
    )
      .foregroundColor(textForegroundColor)
      .padding(.vertical, .grid(2))
      .padding(.horizontal, .grid(4))
      .frame(maxWidth: .infinity, minHeight: 44)
      .background(backgroundColor)
      .adaptiveCornerRadius(.allCorners, 8)
      .shadow(
        color: Color.black.opacity(0.1),
        radius: 5,
        x: 0,
        y: 4
      )
      .compositingGroup()
  }
  
  private var textForegroundColor: Color {
    switch infobar.style {
    case .criticalMass:
      return Color(.label)
    case .success, .warning, .error:
      return Color.white
    }
  }
  
  private var icon: some View {
    switch infobar.style {
    case .criticalMass:
      return Image(systemName: "pencil")
    case .success:
      return Image(systemName: "checkmark.circle")
    case .warning, .error:
      return Image(systemName: "exclamationmark.triangle.fill")
    }
  }
  
  private var backgroundColor: some View {
    switch infobar.style {
    case .criticalMass:
      return Color(.secondaryBackground)
    case .success:
      return Color.green
    case .warning, .error:
      return Color.hex(0xFF3355)
    }
  }
}

struct InfobarView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      VStack {
        InfobarView(.criticalMass(message: "CriticalMass", subTitle: "12.12.2012 am Mariannenplatz"))
        InfobarView(.success(message: "Infobar Success"))
        InfobarView(.warning(message: "Infobar Warning"))
        InfobarView(.error(message: "Infobar Error"))
      }      
    }
  }
}
