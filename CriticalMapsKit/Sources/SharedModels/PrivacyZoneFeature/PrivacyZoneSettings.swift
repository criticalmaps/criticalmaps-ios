import Foundation
import IdentifiedCollections

public struct PrivacyZoneSettings: Codable, Equatable {
  public var isEnabled: Bool
  public var zones: IdentifiedArrayOf<PrivacyZone>
  public var defaultRadius: Double
  public var shouldShowZonesOnMap: Bool
  
  public var canShowOnMap: Bool { shouldShowZonesOnMap && isEnabled }
  
  public init(
    isEnabled: Bool = false,
    zones: IdentifiedArrayOf<PrivacyZone> = [],
    defaultRadius: Double = 400,
    shouldShowZonesOnMap: Bool = true
  ) {
    self.isEnabled = isEnabled
    self.zones = zones
    self.defaultRadius = defaultRadius
    self.shouldShowZonesOnMap = shouldShowZonesOnMap
  }
  
  /// Returns active zones only
  public var activeZones: [PrivacyZone] {
    zones.filter(\.isActive)
  }
    
  /// Check if any active zone contains the given coordinate
  public func isLocationInPrivacyZone(_ coordinate: Coordinate) -> Bool {
    guard isEnabled else { return false }
    return activeZones.contains { $0.contains(coordinate) }
  }
  
  /// Find all active zones that contain the given coordinate
  public func privacyZonesContaining(_ coordinate: Coordinate) -> [PrivacyZone] {
    guard isEnabled else { return [] }
    return activeZones.filter { $0.contains(coordinate) }
  }
  
  /// Add a new privacy zone
  public mutating func addZone(_ zone: PrivacyZone) {
    zones.append(zone)
  }
  
  /// Remove a privacy zone by ID
  public mutating func removeZone(withID id: UUID) {
    zones.removeAll { $0.id == id }
  }
  
  /// Update an existing privacy zone
  public mutating func updateZone(_ updatedZone: PrivacyZone) {
    if let index = zones.firstIndex(where: { $0.id == updatedZone.id }) {
      zones[index] = updatedZone
    }
  }
  
  /// Toggle the active state of a zone
  public mutating func toggleZone(withID id: UUID) {
    zones[id: id]?.isActive.toggle()
  }
  
  /// Get zone by ID
  public func zone(withID id: UUID) -> PrivacyZone? {
    zones.first { $0.id == id }
  }
  
  /// Check if there are any overlapping zones
  public var hasOverlappingZones: Bool {
    for (index, zone) in activeZones.enumerated() {
      for otherZone in activeZones.dropFirst(index + 1) {
        let distance = zone.center.distance(from: otherZone.center)
        if distance < (zone.radius + otherZone.radius) {
          return true
        }
      }
    }
    return false
  }
  
  /// Find overlapping zones
  public var overlappingZonePairs: [(PrivacyZone, PrivacyZone)] {
    var pairs: [(PrivacyZone, PrivacyZone)] = []
    
    for (index, zone) in activeZones.enumerated() {
      for otherZone in activeZones.dropFirst(index + 1) {
        let distance = zone.center.distance(from: otherZone.center)
        if distance < (zone.radius + otherZone.radius) {
          pairs.append((zone, otherZone))
        }
      }
    }
    
    return pairs
  }
}
