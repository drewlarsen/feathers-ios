import SwiftUI

struct MinituresView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Minitures Coming Soon")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
} 