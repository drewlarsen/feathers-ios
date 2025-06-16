import SwiftUI
import MasonryStack
import SDWebImageSwiftUI

struct SpiritCardView: View {
    let spirit: Spirit
    
    var body: some View {
        WebImage(url: spirit.image_full_url_sm)
            .resizable()
            .indicator(.activity)
            .transition(.fade)
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(2)
    }
}

struct SpiritsView: View {
    @State private var spirits: [Spirit] = []
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
            if let error = error {
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
                            WebImage(url: spirit.image_full_url_sm)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(2)
                                .shadow(radius: 2, y: 1)
                        }
                    }
                }
                .padding(.horizontal, spacing)
                .padding(.vertical, spacing)
                .padding(.bottom, 80)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: columnCount)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: spacing)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: shuffleTrigger)
            }
        }
        .background(Color(uiColor: .systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if spirits.isEmpty {
                loadSpirits()
            }
        }
        .onChange(of: shuffleTrigger) { _ in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                spirits.shuffle()
            }
        }
    }
    
    private func loadSpirits() {
        APIService.shared.fetchSpirits { result in
            switch result {
            case .success(let spirits):
                self.spirits = spirits.shuffled()
            case .failure(let error):
                self.error = error
            }
        }
    }
} 
