//
//  File.swift
//  
//
//  Created by Malte on 27.06.21.
//

import SwiftUI

public extension Image {
  func iconModifier() -> some View {
    self
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 30, height: 30)
      .foregroundColor(Color(.label))
  }
}
