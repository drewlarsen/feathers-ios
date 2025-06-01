import SwiftUI

struct SpiritsView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Text("Spirits Coming Soon")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Spirits")
        }
    }
} 