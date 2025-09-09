import SharedModels
import Styleguide
import SwiftUI

struct ZoneRow: View {
  let zone: PrivacyZone
  var toggleBinding: Binding<Bool>
  let onDelete: () -> Void
    
  var body: some View {
    HStack(spacing: .grid(3)) {
      // Status indicator
      Circle()
        .fill(zone.isActive ? Color.green : Color.secondary)
        .frame(width: 8, height: 8)
      
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(zone.name)
          .font(.body)
          .fontWeight(.medium)
        
        HStack(spacing: .grid(4)) {
          Label("\(Int(zone.radius))m", systemImage: "circle.dashed")
            .font(.caption)
            .foregroundColor(.secondary)
          
          Label(
            zone.createdAt
              .formatted(.dateTime.day().month().hour().minute()),
            systemImage: "calendar"
          )
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      
      Spacer()
      
      Button(action: {
        toggleBinding.wrappedValue.toggle()
      }) {
        Image(systemName: zone.isActive ? "location.fill" : "location.slash.fill")
          .font(.title3)
          .foregroundColor(zone.isActive ? .green : .secondary)
          .frame(width: 32, height: 32)
          .background(
            Circle()
              .fill(zone.isActive ? Color.green.opacity(0.15) : Color.secondary.opacity(0.1))
              .stroke(zone.isActive ? Color.green.opacity(0.3) : Color.secondary.opacity(0.2), lineWidth: 1)
          )
      }
      .buttonStyle(.plain)
      .symbolTransition()
    }
    .padding(.vertical, .grid(1))
    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
      Button("Delete", role: .destructive) {
        onDelete()
      }
    }
    .opacity(zone.isActive ? 1.0 : 0.7)
  }
}

#Preview {
  ZoneRow(
    zone: PrivacyZone(
      name: "My Zone",
      center: Coordinate(
        latitude: 54.312,
        longitude: 13.34
      ),
      radius: 400
    ),
    toggleBinding: .constant(true),
    onDelete: {}
  )
}
