@testable import MapFeature
import SharedModels
import Testing

@MainActor
@Suite("RiderActivityFilter")
struct RiderActivityFilterTests {
  init() {
    // Reset static state between tests
    RiderAnnotationUpdateClient.previousPositions = [:]
  }
	
  // MARK: - Helpers

  /// Places riders in a tight cluster (< 250m apart) around a base coordinate
  private func makeCluster(
    around base: Coordinate,
    count: Int,
    startID: Int = 0
  ) -> [Rider] {
    (0 ..< count).map { i in
      Rider(
        id: "rider-\(startID + i)",
        location: .init(
          coordinate: Coordinate(
            latitude: base.latitude + Double(i) * 0.0005, // ~55m steps
            longitude: base.longitude
          ),
          timestamp: 0
        )
      )
    }
  }

  private let berlin = Coordinate(latitude: 52.520, longitude: 13.405)
  private let hamburg = Coordinate(latitude: 53.550, longitude: 10.000)

  // MARK: - Isolation

  @Test
  func `Single rider is never active`() {
    let riders = [Rider(id: "solo", location: .init(coordinate: berlin, timestamp: 0))]
    #expect(RiderActivityFilter.classify(riders).isEmpty)
  }

  @Test
  func `Two riders close together are never active`() {
    let riders = makeCluster(around: berlin, count: 2)
    #expect(RiderActivityFilter.classify(riders).isEmpty)
  }

  @Test
  func `Completely isolated rider is inactive regardless of ID count`() {
    var riders = makeCluster(around: berlin, count: 10)
    let loner = Rider(id: "loner", location: .init(coordinate: hamburg, timestamp: 0))
    riders.append(loner)

    let activeIDs = RiderActivityFilter.classify(riders)
    #expect(!activeIDs.contains("loner"))
  }

  // MARK: - Activation conditions

  @Test
  func `3+ short-range neighbors → active (condition 1)`() {
    let riders = makeCluster(around: berlin, count: 4)
    let activeIDs = RiderActivityFilter.classify(riders)
    #expect(activeIDs.count == 4)
  }

  @Test
  func `2 short-range + sparse long-range → active (condition 2)`() {
    // 3 riders close together (each has 2 short-range neighbours)
    // + 10 riders within 8km but outside 250m (longRange = 12 < 15)
    var riders = makeCluster(around: berlin, count: 3)
    riders += (0 ..< 10).map { i in
      Rider(
        id: "far-\(i)",
        location: .init(
          coordinate: Coordinate(
            latitude: berlin.latitude + Double(i + 1) * 0.02,
            longitude: berlin.longitude
          ),
          timestamp: 0
        )
      )
    }
    let activeIDs = RiderActivityFilter.classify(riders)
    // The tight cluster of 3 should be active
    #expect(activeIDs.contains("rider-0"))
    #expect(activeIDs.contains("rider-1"))
    #expect(activeIDs.contains("rider-2"))
  }

  @Test
  func `All 3 conditions fail → cluster is inactive`() {
    // 3 close riders at ~55m steps
    var riders = makeCluster(around: berlin, count: 3)

    // 0.0072° ≈ 800m per step
    // 8km / 800m = 10 slots → riders at steps 1–10 are inside, steps 11+ are outside
    // We need 15 inside, so use smaller steps: 0.004° ≈ 445m
    // 8km / 445m ≈ 17 slots → steps 1–17 inside ✓
    riders += (0 ..< 20).map { i in
      Rider(
        id: "far-\(i)",
        location: .init(
          coordinate: Coordinate(
            latitude: berlin.latitude + Double(i + 1) * 0.004,
            longitude: berlin.longitude
          ),
          timestamp: 0
        )
      )
    }

    // Verify geometry assumptions
    let closeToFarDist = riders[0].coordinate.distance(to: riders[3].coordinate)
    #expect(closeToFarDist > 250, "First far rider must be outside short range")
    #expect(closeToFarDist < 8000, "First far rider must be inside long range")

    // Verify longRange count for rider-0
    let rider0 = riders[0]
    let longRangeCount = riders.count(where: { other in
      other.id != rider0.id &&
        rider0.coordinate.distance(to: other.coordinate) <= 8000
    })
    let shortRangeCount = riders.count(where: { other in
      other.id != rider0.id &&
        rider0.coordinate.distance(to: other.coordinate) <= 250
    })

    #expect(shortRangeCount == 2, "rider-0 should have exactly 2 short-range neighbors")
    #expect(longRangeCount >= 7, "rider-0 should have >= 7 long-range neighbors to fail condition 3")
    #expect(longRangeCount >= 15, "rider-0 should have >= 15 long-range neighbors to fail condition 2")

    let activeIDs = RiderActivityFilter.classify(riders)
    #expect(!activeIDs.contains("rider-0"))
    #expect(!activeIDs.contains("rider-1"))
    #expect(!activeIDs.contains("rider-2"))
  }

  // MARK: - Multiple independent groups

  @Test
  func `Two separate groups are both classified independently`() {
    let groupA = makeCluster(around: berlin, count: 5, startID: 0)
    let groupB = makeCluster(around: hamburg, count: 5, startID: 5)
    let activeIDs = RiderActivityFilter.classify(groupA + groupB)

    // All riders in both groups should be active
    #expect(activeIDs.count == 10)
    groupA.forEach { #expect(activeIDs.contains($0.id)) }
    groupB.forEach { #expect(activeIDs.contains($0.id)) }
  }

  @Test
  func `Lone rider between two large groups stays inactive`() {
    let groupA = makeCluster(around: berlin, count: 10, startID: 0)
    let groupB = makeCluster(around: hamburg, count: 10, startID: 10)
    // Place loner halfway between — within 8km of both groups
    let midpoint = Coordinate(latitude: 53.035, longitude: 11.700)
    let loner = Rider(id: "loner", location: .init(coordinate: midpoint, timestamp: 0))

    let activeIDs = RiderActivityFilter.classify(groupA + groupB + [loner])
    #expect(!activeIDs.contains("loner"))
  }
}
