//
//  ContentView.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var feathers: [Feather] = []
    @State private var currentIndex: Int = 0

    var body: some View {
        Group {
            if feathers.isEmpty {
                ProgressView("Loading...")
                    .onAppear { load() }
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(feathers.indices, id: \.self) { idx in
                        FeatherCardView(feather: feathers[idx])
                            .tag(idx)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeOut, value: currentIndex)
            }
        }
    }

    private func load() {
        APIService.shared.fetchFeathers { result in
            switch result {
            case .success(let list): feathers = list.sorted { $0.id < $1.id }
            case .failure(let err): print("Error fetching: \(err)")
            }
        }
    }
}
