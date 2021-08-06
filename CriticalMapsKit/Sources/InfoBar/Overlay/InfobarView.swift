import Helpers
import SwiftUI
import Styleguide

public struct InfobarView: View {
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
            .font(.bodyTwo)
          if let subTitle = infobar.subTitle {
            Text(subTitle)
              .lineLimit(1)
              .font(.meta)
          }
        }
        Spacer(minLength: 0)
      }
    )
    .foregroundColor(textForegroundColor)
    .padding(.vertical, .grid(3))
    .padding(.horizontal, .grid(4))
    .frame(maxWidth: .infinity, minHeight: 68)
    .background(backgroundColor)
    .adaptiveCornerRadius(.allCorners, 18)
    .shadow(
      color: Color.black.opacity(0.1),
      radius: 5,
      x: 0,
      y: 4
    )
    .compositingGroup()
  }
  
  var textForegroundColor: Color {
    switch infobar.style {
    case .criticalMass:
      return Color(.textPrimary)
    case .success, .warning, .error:
      return Color.white
    }
  }
  
  var icon: some View {
    switch infobar.style {
    case .criticalMass:
      return Image(uiImage: Images.eventMarker)
    case .success:
      return Image(systemName: "checkmark.circle")
    case .warning, .error:
      return Image(systemName: "exclamationmark.triangle.fill")
    }
  }
  
  var backgroundColor: some View {
    switch infobar.style {
    case .criticalMass:
      return Color(.backgroundSecondary)
    case .success:
      return Color.green
    case .warning, .error:
      return Color(.attention)
    }
  }
}

struct InfobarView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      VStack {
        InfobarView(
          .criticalMass(
            message: "CriticalMass am Mariannenplatz",
            subTitle: "12.12.2012"
          )
        )
        InfobarView(.success(message: "Infobar Success"))
        InfobarView(.warning(message: "Infobar Warning"))
        InfobarView(.error(message: "Infobar Error"))
      }
    }
  }
}
