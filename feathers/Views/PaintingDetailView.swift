import SwiftUI
import SDWebImageSwiftUI

struct PaintingDetailView: View {
    let painting: Painting
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingWebSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Image
                WebImage(url: painting.image_full_url_lg)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(2)
                    .shadow(radius: 2, y: 1)
                    .padding(.horizontal)
                
                // Title and Details
                VStack(alignment: .leading, spacing: 16) {
                    Text(painting.display_title)
                        .font(.system(size: 28, weight: .regular, design: .serif))
                    
                    HStack {
                        Text("\(painting.dimensions) — \(painting.price_display) — ")
                        Text(painting.is_original_available ? "Available" : "Sold")
                            .foregroundColor(painting.is_original_available ? .green : .red)
                    }
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
        .navigationTitle(painting.collection_name)
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
            if let url = painting.web_url {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    private func sharePainting() {
        guard let url = painting.web_url else { return }
        
        let items: [Any] = [
            painting.share_text,
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
