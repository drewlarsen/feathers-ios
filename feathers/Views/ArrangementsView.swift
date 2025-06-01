import SwiftUI

struct ArrangementsView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Text("Arrangements Coming Soon")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Arrangements")
        }
    }
} 