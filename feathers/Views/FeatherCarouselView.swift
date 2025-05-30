//
//  FeatherCarouselView.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//


// File: Views/FeatherCarouselView.swift
import SwiftUI

struct FeatherCarouselView: View {
    let feathers: [Feather]
    @Binding var currentIndex: Int
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                if let url = feathers[currentIndex].imageUrlLg {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .offset(x: dragOffset.width)
                    } placeholder: {
                        ProgressView()
                    }
                }
                Text("#\(feathers[currentIndex].number) \(feathers[currentIndex].name ?? "")")
                    .font(.headline)
                    .padding(8)
                    .padding([.top, .leading], 16)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.easeOut(duration: 0.3)) {
                            handleSwipe(value)
                        }
                    }
            )
        }
    }

    private func handleSwipe(_ val: DragGesture.Value) {
        let h = val.translation.width, v = val.translation.height
        if abs(h) > abs(v) {
            currentIndex = h < 0 ? min(currentIndex+1, feathers.count-1) : max(currentIndex-1, 0)
        } else {
            if v < 0,
               let str = feathers[currentIndex].complementary_feather_ids.first,
               let id = Int(str),
               let idx = feathers.firstIndex(where: { $0.id == id }) {
                currentIndex = idx
            }
            if v > 0,
               let str = feathers[currentIndex].triad_1_feather_ids.first,
               let id = Int(str),
               let idx = feathers.firstIndex(where: { $0.id == id }) {
                currentIndex = idx
            }
        }
    }
}

