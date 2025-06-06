import SwiftUI
import MasonryStack

struct ArrangementCardView: View {
    let arrangement: Arrangement
    let showNumber: Bool
    
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
            
            if showNumber {
                Text("#\(arrangement.number)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
        .background(Color.white)
        .cornerRadius(2)
        .animation(.spring(response: 0.3), value: showNumber)
    }
}

struct ArrangementsView: View {
    @State private var arrangements: [Arrangement] = []
    @State private var isLoading = false
    @State private var error: Error?
    @Binding var columnCount: Int
    let shuffleTrigger: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var spacing: CGFloat {
        switch columnCount {
        case 1: return 16
        case 2: return 12
        case 3: return 8
        case 4: return 6
        default: return 12
        }
    }
    
    var body: some View {
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
                MasonryVStack(columns: columnCount, spacing: spacing) {
                    ForEach(arrangements) { arrangement in
                        NavigationLink {
                            PaintingDetailView(painting: arrangement)
                        } label: {
                            ArrangementCardView(
                                arrangement: arrangement,
                                showNumber: columnCount < 3
                            )
                        }
                    }
                }
                .padding(.horizontal, spacing)
                .padding(.vertical)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: columnCount)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: spacing)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: shuffleTrigger)
            }
        }
        .background(Color(uiColor: .systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            loadArrangements()
        }
        .onChange(of: shuffleTrigger) { _ in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                arrangements.shuffle()
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
                self.arrangements = arrangements.filter { $0.is_active }.shuffled()
            case .failure(let error):
                self.error = error
            }
        }
    }
} 
