//
//  ContentView.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var feathers: [Feather] = []
    @State private var currentIndex: Int    = 0
    @State private var renderedCardSize     = CGSize.zero
    
    @State private var isShowingWebSheet = false
    
    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width * 0.8
    }
    private var cardHeight: CGFloat {
        cardWidth * 2
    }
    private let shadowPadding: CGFloat = 20
    
    /// White if no feathers yet, otherwise the current feather's light_color_rgb
    private var backgroundColor: Color {
        guard !feathers.isEmpty,
              let rgb = feathers[currentIndex].light_color_rgb
        else { return .white }
        return Color.fromRGBString(rgb)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: currentIndex)
            
            if feathers.isEmpty {
                ProgressView("Loading…")
                    .onAppear { load() }
            } else {
                VStack(spacing: 8) {
                    TabView(selection: $currentIndex) {
                        ForEach(feathers.indices, id: \.self) { idx in
                            FeatherCardView(feather: feathers[idx])
                            // 1: fix each card to the 1:2 ratio
                                .frame(width: cardWidth, height: cardHeight)
                            // 2: apply parallax + focus scaling
                                .scaleEffect(idx == currentIndex ? 1 : 0.95)
                            //                  .rotation3DEffect(
                            //                    Angle(degrees: Double(idx - currentIndex) * 10),
                            //                    axis: (x: 0, y: 1, z: 0),
                            //                    perspective: 0.7
                            //                  )
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                                .tag(idx)
                                .onTapGesture {
                                    isShowingWebSheet = true
                                }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    .frame(height: cardHeight + shadowPadding * 2)
                    
                    
                    Text("\(feathers[currentIndex].name ?? "")")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    //          Text("Rendered: \(Int(renderedCardSize.width)) x \(Int(renderedCardSize.height)) px")
                    //            .font(.subheadline)
                    //            .foregroundColor(.secondary)
                    
                    HStack(spacing: 40) {
                        Button {
                            currentIndex = 0
                        } label: {
                            Image(systemName: "backward.end")
                                .font(.title2)
                        }
                        
                        Button {
                            currentIndex = Int.random(in: 0..<feathers.count)
                        } label: {
                            Image(systemName: "shuffle")
                                .font(.title2)
                        }
                        
                        Button {
                            currentIndex = feathers.count - 1
                        } label: {
                            Image(systemName: "forward.end")
                                .font(.title2)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingWebSheet) {
            // Construct the URL using the current feather’s number:
            if let url = URL(string: "https://www.shaynalarsen.art/feathers/\(feathers[currentIndex].number)") {
                WebView(url: url)                       // WebView is your UIKit wrapper around WKWebView
                    .edgesIgnoringSafeArea(.bottom)
            } else {
                Color.white  // Fallback if URL creation fails
            }
        }
    }
    
    private func load() {
        APIService.shared.fetchFeathers { result in
            switch result {
            case .success(let list):
                let sorted = list.sorted { $0.id < $1.id }
                feathers = sorted
                if !sorted.isEmpty {
                    currentIndex = Int.random(in: 0..<sorted.count)
                }
            case .failure(let err):
                print("Error fetching: \(err)")
            }
        }
    }
}
