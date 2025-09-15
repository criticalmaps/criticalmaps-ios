import ComposableArchitecture
import L10n
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
        .font(.title)
        .foregroundStyle(foregroundStyleColor)
        .accessibilityHidden(true)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(accessibilityLabel)
    .accessibilityValue(accessibilityValue)
  }
  
  // MARK: - Presentation
  
  private var statusText: String {
    if !privacyZoneSettings.isEnabled {
      L10n.PrivacyZone.Tile.StatusText.off
    } else if isInPrivacyZone {
      L10n.PrivacyZone.Tile.StatusText.hidden
    } else {
      L10n.PrivacyZone.Tile.StatusText.on
    }
  }
  
  private var foregroundStyleColor: Color {
    if !privacyZoneSettings.isEnabled {
      Color.secondary
    } else if isInPrivacyZone {
      Color.green
    } else {
      Color.primary
    }
  }
  
  @ViewBuilder
  private var icon: some View {
    if !privacyZoneSettings.isEnabled {
      Asset.pzLocationShieldSlash.swiftUIImage
        .renderingMode(.template)
    } else if isInPrivacyZone {
      Asset.pzLocationShield.swiftUIImage
        .renderingMode(.template)
    } else {
      Asset.pzLocationShield.swiftUIImage
        .renderingMode(.template)
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
    @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
      isEnabled: true,
      zones: [.init(
        name: "",
        center: Coordinate(latitude: 53.31, longitude: 13.43),
        radius: 400
      )],
      defaultRadius: 400,
      shouldShowZonesOnMap: true
    )
    
    PrivacyStatusTile(isInPrivacyZone: true)  // Location Hidden
    
    PrivacyStatusTile(isInPrivacyZone: false) // Zones Off
      .environment(\.colorScheme, .light)
      .environment(\.dynamicTypeSize, .accessibility2)
  }
  .padding()
}
