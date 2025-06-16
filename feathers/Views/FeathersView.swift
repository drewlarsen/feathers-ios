import SwiftUI
import WebKit
import MasonryStack
import SDWebImageSwiftUI

struct FeatherCardView: View {
    let feather: Feather
    let showNumber: Bool
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            WebImage(url: feather.image_full_url_sm)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
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
    @State private var error: Error?
    @Binding var columnCount: Int
    let shuffleTrigger: Bool
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
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
            if let error = error {
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
                            WebImage(url: feather.image_full_url_sm)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(2)
                                .shadow(radius: 2, y: 1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, spacing)
                .padding(.vertical, spacing)
                .padding(.bottom, 80)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: shuffleTrigger)
            }
        }
        .background(Color(uiColor: .systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: columnCount)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: spacing)
        .onAppear {
            if feathers.isEmpty {
                loadFeathers()
            }
        }
        .onChange(of: shuffleTrigger) { _ in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                feathers.shuffle()
            }
        }
    }
    
    private func loadFeathers() {
        APIService.shared.fetchFeathers { result in
            switch result {
            case .success(let feathers):
                self.feathers = feathers.shuffled()
            case .failure(let error):
                self.error = error
            }
        }
    }
} 
