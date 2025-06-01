//
//  FeatherCardView.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import SwiftUI

struct FeatherCardView: View {
    let feather: Feather
    
    var body: some View {
        if let url = feather.imageUrlLg {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: url) { img in
                    img
                        .resizable()
                        .scaledToFill()
                        // .clipped()
                } placeholder: {
                    ProgressView()
                }
                
                Text("#\(feather.number)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .background(Color.red.opacity(0.1)) // Temporary background to see frame
        }
    }
}
