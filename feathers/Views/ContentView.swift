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
    @State private var spiritsColumns = 2
    @State private var feathersColumns = 4
    @State private var arrangementsColumns = 2
    
    private var currentMaxColumns: Int {
        switch selectedTab {
        case 0: return 4  // Spirits
        case 1: return 8  // Feathers
        case 2: return 4  // Arrangements
        default: return 4
        }
    }
    
    private var currentColumnBinding: Binding<Int> {
        switch selectedTab {
        case 0: return $spiritsColumns
        case 1: return $feathersColumns
        case 2: return $arrangementsColumns
        default: return .constant(2)
        }
    }
    
    init() {
        // Configure Tab Bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemGray6
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Configure Navigation Bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                SpiritsView(columnCount: $spiritsColumns)
                    .tabItem {
                        Label("Mountain Spirits", systemImage: "mountain.2")
                    }
                    .tag(0)
                
                FeathersView(columnCount: $feathersColumns)
                    .tabItem {
                        Label("500 Feathers", systemImage: "leaf")
                    }
                    .tag(1)
                
                ArrangementsView(columnCount: $arrangementsColumns)
                    .tabItem {
                        Label("Arrangements", systemImage: "square.stack.3d.up")
                    }
                    .tag(2)
                
                MinituresView()
                    .tabItem {
                        Label("Minitures", systemImage: "photo.artframe")
                    }
                    .tag(3)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(tabTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedTab != 3 { // Don't show for Minitures
                        GridLayoutButton(columnCount: currentColumnBinding, 
                                      maxColumns: currentMaxColumns)
                    }
                }
            }
        }
    }
    
    private var tabTitle: String {
        switch selectedTab {
        case 0:
            return "Mountain Spirits"
        case 1:
            return "500 Feathers"
        case 2:
            return "Arrangements"
        case 3:
            return "Minitures"
        default:
            return ""
        }
    }
}
