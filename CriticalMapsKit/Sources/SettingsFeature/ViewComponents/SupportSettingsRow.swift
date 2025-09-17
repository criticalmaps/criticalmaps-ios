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
            .shadow(color: textStackForegroundColor.opacity(0.15), radius: 4)
            .font(.body.bold())
            .padding(.grid(1))
          }
        )
        .padding(.top, 2)
      }
      .accessibilityElement(children: .combine)
      .padding([.top, .bottom, .leading], .grid(6))
      .padding(.trailing, 120)
      .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
      .foregroundColor(colorSchemeContrast.isIncreased ? Color.backgroundPrimary : textStackForegroundColor)
    }
    .background(
      Group {
        if colorSchemeContrast.isIncreased {
          Color.textPrimary
        } else {
          backgroundColor
            .overlay {
              LinearGradient(
                colors: [.clear, .white.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            }
        }
      }
    )
    .clipShape(RoundedRectangle(cornerRadius: 24))
  }
}

#Preview {
  SupportSettingsRow(
    title: "Development",
    subTitle: "Critical Maps is open source and we are always looking for people making this project better",
    link: "GitHub",
    textStackForegroundColor: .textPrimary,
    backgroundColor: .yellow,
    bottomImage: { Asset.ghLogo.swiftUIImage },
    action: {}
  )
}
