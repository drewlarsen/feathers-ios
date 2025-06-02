//
//  ContentView.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        
        // Use this appearance for both normal and scrolling
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SpiritsView()
                .tabItem {
                    Label("Mountain Spirits", systemImage: "sparkles")
                }
                .tag(0)
            
            FeathersView()
                .tabItem {
                    Label("500 Feathers", systemImage: "sparkles")
                }
                .tag(1)
            
            ArrangementsView()
                .tabItem {
                    Label("Arrangements", systemImage: "sparkles")
                }
                .tag(2)
            
            MinituresView()
                .tabItem {
                    Label("Minitures", systemImage: "sparkles")
                }
                .tag(3)
        }
    }
}
