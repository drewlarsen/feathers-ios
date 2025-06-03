import SwiftUI
import WebKit
import MasonryStack

struct FeatherCardView: View {
    let feather: Feather
    let showNumber: Bool
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: feather.imageUrlSm) { phase in
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
                Text("#\(feather.number)")
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

struct FeathersView: View {
    @State private var feathers: [Feather] = []
    @State private var isLoading = false
    @State private var error: Error?
    @Binding var columnCount: Int
    
    private var spacing: CGFloat {
        switch columnCount {
        case 1: return 16
        case 2: return 12
        case 3...4: return 8
        case 5...6: return 6
        case 7...8: return 4
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
                    Text("Failed to load feathers")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Retry") {
                        loadFeathers()
                    }
                    .padding()
                }
                .padding()
            } else {
                MasonryVStack(columns: columnCount, spacing: spacing) {
                    ForEach(feathers) { feather in
                        NavigationLink {
                            PaintingDetailView(painting: feather)
                        } label: {
                            FeatherCardView(feather: feather, showNumber: columnCount <= 4)
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, spacing)
                .padding(.vertical, spacing)
            }
        }
        .background(Color(uiColor: .systemGray6))
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: columnCount)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: spacing)
        .onAppear {
            loadFeathers()
        }
    }
    
    private func loadFeathers() {
        isLoading = true
        error = nil
        
        APIService.shared.fetchFeathers { result in
            isLoading = false
            switch result {
            case .success(let feathers):
                self.feathers = feathers.sorted { $0.id < $1.id }
            case .failure(let error):
                self.error = error
            }
        }
    }
} 
