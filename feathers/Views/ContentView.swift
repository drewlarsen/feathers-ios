//
//  ContentView.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var shuffleState = ShuffleState()
    @State private var selectedTab = 0
    @State private var isLandscape = UIDevice.current.orientation.isLandscape
    @State private var spiritsColumns = OrientationAwareColumns.spirits.portrait
    @State private var feathersColumns = OrientationAwareColumns.feathers.portrait
    @State private var arrangementsColumns = OrientationAwareColumns.arrangements.portrait
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                SpiritsView(columnCount: $spiritsColumns, shuffleTrigger: shuffleState.spiritsTrigger)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                ShuffleButton { shuffleState.shuffleCurrent(tab: selectedTab) }
                                GridLayoutButton(columnCount: $spiritsColumns, maxColumns: isLandscape ? 4 : 3)
                            }
                        }
                    }
                    .navigationTitle("Mountain Spirits")
            }
            .tabItem { Label("Mountain Spirits", systemImage: "mountain.2") }
            .tag(0)
            
            NavigationStack {
                FeathersView(columnCount: $feathersColumns, shuffleTrigger: shuffleState.feathersTrigger)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                ShuffleButton { shuffleState.shuffleCurrent(tab: selectedTab) }
                                GridLayoutButton(columnCount: $feathersColumns, maxColumns: isLandscape ? 8 : 6)
                            }
                        }
                    }
                    .navigationTitle("500 Feathers")
            }
            .tabItem { Label("500 Feathers", systemImage: "leaf") }
            .tag(1)
            
            NavigationStack {
                ArrangementsView(columnCount: $arrangementsColumns, shuffleTrigger: shuffleState.arrangementsTrigger)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                ShuffleButton { shuffleState.shuffleCurrent(tab: selectedTab) }
                                GridLayoutButton(columnCount: $arrangementsColumns, maxColumns: isLandscape ? 6 : 4)
                            }
                        }
                    }
                    .navigationTitle("Arrangements")
            }
            .tabItem { Label("Arrangements", systemImage: "square.stack.3d.up") }
            .tag(2)
            
            NavigationStack {
                MinituresView()
                    .navigationTitle("Minitures")
            }
            .tabItem { Label("Minitures", systemImage: "photo.artframe") }
            .tag(3)
        }
        .onRotate { orientation in
            withAnimation(.spring(response: 0.3)) {
                isLandscape = orientation.isLandscape
                updateColumnsForOrientation()
            }
        }
    }
    
    private func updateColumnsForOrientation() {
        if isLandscape {
            spiritsColumns = OrientationAwareColumns.spirits.landscape
            feathersColumns = OrientationAwareColumns.feathers.landscape
            arrangementsColumns = OrientationAwareColumns.arrangements.landscape
        } else {
            spiritsColumns = OrientationAwareColumns.spirits.portrait
            feathersColumns = OrientationAwareColumns.feathers.portrait
            arrangementsColumns = OrientationAwareColumns.arrangements.portrait
        }
    }
}
