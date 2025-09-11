import SharedModels
import Styleguide
import SwiftUI

struct ZoneRow: View {
  let zone: PrivacyZone
  var toggleBinding: Binding<Bool>
  let onDelete: () -> Void
    
  var body: some View {
    HStack(spacing: .grid(4)) {
      // Status indicator
      Image(systemName: zone.isActive ? "location.slash.fill" : "location.fill")
        .font(.title3)
        .foregroundColor(zone.isActive ? .green : .secondary)
        .frame(width: 32, height: 32)
        .background(
          Circle()
            .fill(zone.isActive ? Color.green.opacity(0.15) : Color.secondary.opacity(0.1))
            .stroke(zone.isActive ? Color.green.opacity(0.3) : Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .symbolTransition()
      
      VStack(alignment: .leading, spacing: .grid(3)) {
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
      
      Toggle(isOn: toggleBinding) { EmptyView() }
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
}

#Preview {
  @Previewable @State var isOn: Bool = false
  
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
      toggleBinding: $isOn,
      onDelete: {}
    )
  }
}
