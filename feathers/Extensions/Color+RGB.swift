//
//  Color+RGB.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import SwiftUI

extension Color {
  /// Parse strings like "rgb(233,229,222)" into a Color
  static func fromRGBString(_ rgbString: String) -> Color {
    // strip “rgb(” and “)”
    let nums = rgbString
      .replacingOccurrences(of: "rgb(", with: "")
      .replacingOccurrences(of: ")",     with: "")
      .split(separator: ",")
      .compactMap { Double($0) }

    guard nums.count == 3 else {
      return Color.white
    }

    return Color(
      red:   nums[0] / 255,
      green: nums[1] / 255,
      blue:  nums[2] / 255
    )
  }
}
