import L10n
import Styleguide
import SwiftUI
import SwiftUIHelpers

struct SupportSettingsRow: View {
  @Environment(\.colorSchemeContrast) var colorSchemeContrast

  let title: String
  let subTitle: String
  let link: String
  let textStackForegroundColor: Color
  let backgroundColor: Color
  let bottomImage: Image

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      bottomImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 150, height: 150, alignment: .bottomTrailing)
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: .grid(2)) {
        Text(title)
          .font(.titleOne)
        Text(subTitle)
          .multilineTextAlignment(.leading)
          .font(.bodyTwo)
        HStack {
          Text(link)
            .multilineTextAlignment(.leading)
          Image(systemName: "arrow.right")
        }
        .font(.body.bold())
      }
      .accessibilityElement(children: .combine)
      .padding([.top, .bottom, .leading], .grid(6))
      .padding(.trailing, 120)
      .foregroundColor(colorSchemeContrast.isIncreased ? Color(.backgroundPrimary) : textStackForegroundColor)
      .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
    }
    .background(colorSchemeContrast.isIncreased ? Color(.textPrimary) : backgroundColor)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      SupportSettingsRow(
        title: "Development",
        subTitle: "Critical Maps is open source and we are always looking for people making this project better",
        link: "GitHub",
        textStackForegroundColor: Color(.textPrimary),
        backgroundColor: .yellow,
        bottomImage: Image(systemName: "chevron.left.circle.fill")
      )
    }
  }
}
