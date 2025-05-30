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
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                if let url = feather.imageUrlLg {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }
                Text("#\(feather.number) \(feather.name ?? "")")
                    .font(.headline)
                    .padding(8)
                    .padding([.top, .leading], 16)
            }
            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}
