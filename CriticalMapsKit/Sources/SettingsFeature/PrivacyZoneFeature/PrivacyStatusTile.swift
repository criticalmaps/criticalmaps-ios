import ComposableArchitecture
import SharedModels
import Styleguide
import SwiftUI

public struct PrivacyStatusTile: View {
  @Shared(.privacyZoneSettings) private var privacyZoneSettings
  let isInPrivacyZone: Bool
  
  public init(isInPrivacyZone: Bool) {
    self.isInPrivacyZone = isInPrivacyZone
  }
  
  public var body: some View {
    DataTile(statusText) {
      Image(systemName: iconName)
        .font(.title2)
        .foregroundColor(iconColor)
    }
  }
  
  private var statusText: String {
    if isInPrivacyZone {
      "Location\nProtected"
    } else {
      "Privacy\nZones " + (privacyZoneSettings.isEnabled ? "On" : "Off")
    }
  }
  
  private var iconName: String {
    if isInPrivacyZone {
      "location.slash.circle"
    } else {
      privacyZoneSettings.isEnabled ? "location.slash.circle" : "location.circle"
    }
  }
  
  private var iconColor: Color {
    if isInPrivacyZone {
      .green
    } else {
      privacyZoneSettings.isEnabled ? .green : .primary
    }
  }
}

#Preview {
  HStack {
    PrivacyStatusTile(isInPrivacyZone: false)
    
    PrivacyStatusTile(isInPrivacyZone: true)
    
    PrivacyStatusTile(isInPrivacyZone: false)
  }
  .padding()
}
