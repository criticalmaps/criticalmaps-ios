//
//  File.swift
//  
//
//  Created by Malte on 30.06.21.
//

import SwiftUI

public struct MapNotificationView : View {
  
  public var body: some View {
    HStack(alignment: .center) {
      Image(systemName: "exclamationmark.circle.fill")
        .font(.largeTitle)
        .padding()
      VStack {
        Text("Next Critical Mass at Mariannenplatz starts April 24th, 8am.")
          .lineLimit(2)
      }
      Image(systemName: "multiply")
        .font(.largeTitle)
        .padding()
    }
    .clipShape(RoundedRectangle(cornerRadius: 18))
  }
}

public struct MapNotificationView_Preview: PreviewProvider {
  public static var previews: some View {
    MapNotificationView()
  }
}
