import SharedModels
import Styleguide
import SwiftUI

struct ZoneRow: View {
  let zone: PrivacyZone
  @Binding var isActive: Bool
  let onDelete: () -> Void
  
  var body: some View {
    HStack(spacing: .grid(4)) {
      // Status indicator
      icon()
        .font(.title2)
        .foregroundColor(zone.isActive ? .green : .secondary)
        .frame(width: 38, height: 38)
        .background(
          Circle()
            .stroke(
              zone.isActive
              ? Color.green.opacity(0.3)
              : Color.secondary.opacity(0.2),
              style: zone.isActive
              ? StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round)
              : StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round, dash: [5, 3], dashPhase: 0)
            )
        )
        .symbolTransition()
      
      VStack(alignment: .leading, spacing: .grid(2)) {
        Text(zone.name)
          .font(.body)
          .fontWeight(.medium)
        
        HStack(alignment: .center, spacing: .grid(4)) {
          HStack(spacing: .grid(2)) {
            Image(systemName: "circle.dashed")
            Text(zone.radiusMeasurement.formatted())
          }
          
          HStack(spacing: .grid(2)) {
            Image(systemName: "calendar")
            Text(
              zone.createdAt
                .formatted(.dateTime.day().month())
            )
          }
        }
        .font(.callout)
        .foregroundColor(.secondary)
      }
      
      Spacer()
      
      Toggle(isOn: $isActive) { EmptyView() }
        .toggleStyle(.switch)
        .scaleEffect(0.8)
        .tint(Color(.brand600))
    }
    .padding(.vertical, .grid(1))
    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
      Button("Delete", role: .destructive) {
        onDelete()
      }
    }
    .opacity(zone.isActive ? 1.0 : 0.7)
  }
  
  @ViewBuilder
  private func icon() -> some View {
    zone.isActive
    ? Asset.pzLocationShieldSlash.swiftUIImage
    : Asset.pzLocationShield.swiftUIImage
  }
}

#Preview {
  List {
    ZoneRow(
      zone: PrivacyZone(
        name: "My Zone",
        center: Coordinate(
          latitude: 54.312,
          longitude: 13.34
        ),
        radius: 400
      ),
      isActive: .constant(false),
      onDelete: {}
    )
  }
}
