import L10n
import Styleguide
import SwiftUI

struct PrivacyZoneDisabledView: View {
  let buttonTapAction: () -> Void
  
  var body: some View {
    content
  }
  
  @ViewBuilder
  private var content: some View {
    VStack(spacing: .grid(6)) {
      Spacer()
      
      VStack(spacing: .grid(4)) {
        Asset.pzLocationShield.swiftUIImage
          .font(.system(size: 60))
          .foregroundColor(.textSecondary)
        
        VStack(spacing: .grid(2)) {
          Text(L10n.PrivacyZone.Settings.Disabled.headline)
            .font(.title2)
            .foregroundColor(.textPrimary)
            .fontWeight(.semibold)
          
          Text(L10n.PrivacyZone.Settings.Disabled.subheadline)
            .font(.body)
            .foregroundColor(.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, .grid(8))
        }
      }
      
      Button(L10n.PrivacyZone.Settings.Disabled.cta) {
        buttonTapAction()
      }
      .buttonStyle(CMButtonStyle())
      .controlSize(.large)
      
      Spacer()
    }
  }
}

#Preview {
  PrivacyZoneDisabledView {
    print("Button tapped")
  }
}
