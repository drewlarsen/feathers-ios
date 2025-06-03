import SwiftUI

struct PaintingDetailView: View {
    let painting: Painting
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingWebSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Image
                AsyncImage(url: painting.imageUrlLg) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .background(Color.gray.opacity(0.2))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(2)
                .shadow(radius: 2, y: 1)
                .padding(.horizontal)
                
                // Title and Details
                VStack(alignment: .leading, spacing: 16) {
                    Text(painting.displayTitle)
                        .font(.system(size: 28, weight: .regular, design: .serif))
                    
                    Text("\(painting.dimensions) — \(painting.priceDisplay)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    if let description = painting.description {
                        Text(description)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(uiColor: .systemGray6))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(painting.collectionName)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Gallery")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingWebSheet = true
                } label: {
                    Image(systemName: "safari")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    sharePainting()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $isShowingWebSheet) {
            if let url = painting.webUrl {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    private func sharePainting() {
        guard let url = painting.webUrl else { return }
        
        let items: [Any] = [
            painting.shareText,
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
