import SwiftUI
import MasonryStack

struct SpiritCardView: View {
    let spirit: Spirit
    
    var body: some View {
        AsyncImage(url: spirit.imageUrlSm) { phase in
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
        .background(Color.white)
        .cornerRadius(2)
    }
}

struct SpiritsView: View {
    @State private var spirits: [Spirit] = []
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
                    Text("Failed to load spirits")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Retry") {
                        loadSpirits()
                    }
                    .padding()
                }
                .padding()
            } else {
                MasonryVStack(columns: columnCount, spacing: spacing) {
                    ForEach(spirits) { spirit in
                        NavigationLink {
                            PaintingDetailView(painting: spirit)
                        } label: {
                            SpiritCardView(spirit: spirit)
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
            loadSpirits()
        }
        .onChange(of: shuffleTrigger) { _ in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                spirits.shuffle()
            }
        }
    }
    
    private func loadSpirits() {
        isLoading = true
        error = nil
        
        APIService.shared.fetchSpirits { result in
            isLoading = false
            switch result {
            case .success(let spirits):
                self.spirits = spirits.shuffled()
            case .failure(let error):
                self.error = error
            }
        }
    }
} 