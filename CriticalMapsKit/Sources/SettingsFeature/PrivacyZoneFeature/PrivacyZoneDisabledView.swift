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
        Image(systemName: "location.slash.circle.fill")
          .font(.system(size: .grid(15)))
          .foregroundColor(.secondary)
        
        VStack(spacing: .grid(2)) {
          Text("Privacy Zones")
            .font(.title2)
            .fontWeight(.semibold)
          
          Text("Create zones where your location won't be shared with other riders")
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, .grid(8))
        }
      }
      
      Button("Enable Privacy Zones") {
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
