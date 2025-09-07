import ComposableArchitecture
import SharedModels
import Styleguide
import SwiftUI

public struct PrivacyStatusTile: View {
  let isInPrivacyZone: Bool
  let privacyZoneSettings: PrivacyZoneSettings
  
  public init(isInPrivacyZone: Bool, privacyZoneSettings: PrivacyZoneSettings) {
    self.isInPrivacyZone = isInPrivacyZone
    self.privacyZoneSettings = privacyZoneSettings
  }
  
  public var body: some View {
    DataTile(statusText) {
      Image(systemName: iconName)
        .font(.title2)
        .foregroundColor(iconColor)
    }
  }
  
  private var statusText: String {
    if !privacyZoneSettings.isEnabled {
      return "Privacy\nZones Off"
    } else if isInPrivacyZone {
      return "Location\nProtected"
    } else {
      return "Location\nShared"
    }
  }
  
  private var iconName: String {
    if !privacyZoneSettings.isEnabled {
      return "location.slash.circle"
    } else if isInPrivacyZone {
      return "shield.checkered"
    } else {
      return "location.circle"
    }
  }
  
  private var iconColor: Color {
    if !privacyZoneSettings.isEnabled {
      return .secondary
    } else if isInPrivacyZone {
      return .orange
    } else {
      return .green
    }
  }
}

#Preview {
  HStack {
    PrivacyStatusTile(
      isInPrivacyZone: false,
      privacyZoneSettings: PrivacyZoneSettings(isEnabled: true)
    )
    
    PrivacyStatusTile(
      isInPrivacyZone: true,
      privacyZoneSettings: PrivacyZoneSettings(isEnabled: true)
    )
    
    PrivacyStatusTile(
      isInPrivacyZone: false,
      privacyZoneSettings: PrivacyZoneSettings(isEnabled: false)
    )
  }
  .padding()
}
