import SwiftUI

struct ArrangementCardView: View {
    let arrangement: Arrangement
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: arrangement.imageUrlSm) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                case .failure:
                    Image(systemName: "photo")
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color.gray.opacity(0.2))
                @unknown default:
                    EmptyView()
                }
            }
            
            Text("#\(arrangement.number)")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.gray)
                .padding(8)
        }
        .background(Color.white)
        .cornerRadius(2)
    }
}

struct ArrangementsView: View {
    @State private var arrangements: [Arrangement] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView()
                        .padding()
                } else if let error = error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .padding()
                        Text("Failed to load arrangements")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Retry") {
                            loadArrangements()
                        }
                        .padding()
                    }
                    .padding()
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(arrangements) { arrangement in
                            ArrangementCardView(arrangement: arrangement)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Arrangements")
            .onAppear {
                loadArrangements()
            }
        }
    }
    
    private func loadArrangements() {
        isLoading = true
        error = nil
        
        APIService.shared.fetchArrangements { result in
            isLoading = false
            switch result {
            case .success(let arrangements):
                self.arrangements = arrangements.filter { $0.is_active }
            case .failure(let error):
                self.error = error
            }
        }
    }
} 
