import SwiftUI
import MasonryStack

struct SpiritCardView: View {
    let spirit: Spirit
    let onTap: () -> Void
    
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
        .onTapGesture(perform: onTap)
    }
}

struct SpiritsView: View {
    @State private var spirits: [Spirit] = []
    @State private var isLoading = false
    @State private var error: Error?
    @State private var columnCount = 2
    @State private var selectedSpirit: Spirit?
    @State private var isShowingWebSheet = false
    
    private var spacing: CGFloat {
        switch columnCount {
        case 1: return 16
        case 2: return 12
        case 3...4: return 8
        default: return 12
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Columns", selection: $columnCount.animation(.spring(response: 0.35, dampingFraction: 0.8))) {
                    ForEach(1...4, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
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
                                SpiritCardView(
                                    spirit: spirit,
                                    onTap: {
                                        selectedSpirit = spirit
                                        isShowingWebSheet = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, spacing)
                        .padding(.vertical)
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: columnCount)
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: spacing)
                    }
                }
                .background(Color(uiColor: .systemGray6))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Mountain Spirits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let spirit = selectedSpirit {
                        Button {
                            shareSpirit(spirit)
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingWebSheet) {
            if let spirit = selectedSpirit,
               let url = Config.Website.spiritURL(spirit.id) {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onAppear {
            loadSpirits()
        }
    }
    
    private func loadSpirits() {
        isLoading = true
        error = nil
        
        APIService.shared.fetchSpirits { result in
            isLoading = false
            switch result {
            case .success(let spirits):
                self.spirits = spirits.sorted { first, second in
                    // Sort by year first (newest first)
                    if first.year != second.year {
                        return first.year > second.year
                    }
                    // Then by name
                    return first.name < second.name
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    private func shareSpirit(_ spirit: Spirit) {
        guard let url = Config.Website.spiritURL(spirit.id) else { return }
        
        let items: [Any] = [
            "Check out this beautiful \(spirit.name) painting by Shayna Larsen!",
            url
        ]
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
} 