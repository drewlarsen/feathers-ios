import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Text("Settings Coming Soon")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Settings")
        }
    }
} 