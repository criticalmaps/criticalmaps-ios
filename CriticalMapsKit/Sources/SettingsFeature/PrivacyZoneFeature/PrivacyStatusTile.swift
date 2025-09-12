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
      icon
        .font(.title2)
        .accessibilityHidden(true)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(accessibilityLabel)
    .accessibilityValue(accessibilityValue)
  }
  
  // MARK: - Presentation
  
  private var statusText: String {
    if !privacyZoneSettings.isEnabled {
      "Privacy Zones Off"
    } else if isInPrivacyZone {
      "Location Hidden"
    } else {
      "Privacy Zones On"
    }
  }
  
  @ViewBuilder
  private var icon: some View {
    if !privacyZoneSettings.isEnabled {
      Asset.pzLocationShield.swiftUIImage
        .tint(.secondary)
    } else if isInPrivacyZone {
      Asset.pzLocationShieldSlash.swiftUIImage
        .tint(.green)
    } else {
      Asset.pzLocationShieldSlash.swiftUIImage
        .tint(.primary)
    }
  }
  // MARK: - Accessibility
  
  private var accessibilityLabel: String {
    "Privacy status"
  }
  
  private var accessibilityValue: String {
    statusText
  }
}

#Preview {
  HStack(spacing: 16) {
    PrivacyStatusTile(isInPrivacyZone: false) // Zones On
      .environment(\.colorScheme, .dark)
    
    PrivacyStatusTile(isInPrivacyZone: true)  // Location Hidden
    
    PrivacyStatusTile(isInPrivacyZone: false) // Zones Off
      .environment(\.colorScheme, .light)
      .environment(\.dynamicTypeSize, .accessibility2)
      .task {
        @Shared(.privacyZoneSettings) var zones
        $zones.withLock { $0.isEnabled = false }
      }
  }
  .padding()
}
