import L10n
import Styleguide
import SwiftUI
import SwiftUIHelpers

struct SupportSettingsRow<BottomImageView: View>: View {
  @Environment(\.colorSchemeContrast) var colorSchemeContrast

  let title: String
  let subTitle: String
  let link: String
  let textStackForegroundColor: Color
  let backgroundColor: Color
  @ViewBuilder var bottomImage: () -> BottomImageView
  let action: () -> Void

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      bottomImage()

      VStack(alignment: .leading, spacing: .grid(2)) {
        Text(title)
          .font(.titleOne)
        Text(subTitle)
          .multilineTextAlignment(.leading)
          .font(.bodyTwo)
        Button(
          action: action,
          label: {
            HStack {
              Text(link)
                .multilineTextAlignment(.leading)
              Image(systemName: "arrow.up.right")
            }
            .font(.body.bold())
            .padding(4)
          }
        )
        .padding(.top, 2)
      }
      .accessibilityElement(children: .combine)
      .padding([.top, .bottom, .leading], .grid(6))
      .padding(.trailing, 120)
      .foregroundColor(colorSchemeContrast.isIncreased ? Color(.backgroundPrimary) : textStackForegroundColor)
      .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
    }
    .background(
      Group {
        if colorSchemeContrast.isIncreased {
          Color(.textPrimary)
        } else {
          backgroundColor
            .overlay {
              LinearGradient(
                colors: [.clear, .white.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            }
        }
      }
    )
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
        bottomImage: { Image(systemName: "chevron.left.circle.fill") }, 
        action: {}
      )
    }
  }
}
