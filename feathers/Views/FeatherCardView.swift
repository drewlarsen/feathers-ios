//
//  FeatherCardView.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import SwiftUI

struct FeatherCardView: View {
    let feather: Feather
    @State private var pop = false
    
    // MARK: - Layout Constants
    private let cardWidth = UIScreen.main.bounds.width * 0.8
    private var cardHeight: CGFloat { cardWidth * 2 }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let url = feather.imageUrlLg {
                AsyncImage(url: url) { img in
                    img
                        .resizable()
                        .scaledToFill()
                        .frame(width: cardWidth, height: cardHeight)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(width: cardWidth, height: cardHeight)
                }
            }
            // Feather number in monospaced, light gray
            Text("#\(feather.number)")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.gray)
                .padding(8)
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(Color.white)
        .cornerRadius(4)
        .shadow(radius: 5)
        .scaleEffect(pop ? 1 : 0.95)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) { pop = true }
        }
    }
}
