import SwiftUI

struct MiniaturesView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Miniatures Coming Soon")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
} 
