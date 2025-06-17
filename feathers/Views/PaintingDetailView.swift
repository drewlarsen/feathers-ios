import SwiftUI
import SDWebImageSwiftUI

struct FullScreenImageView: View {
    let url: URL?
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var viewOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            WebImage(url: url)
                .resizable()
                .indicator(.activity)
                .transition(.fade)
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
                .offset(y: viewOffset)
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastScale
                            lastScale = value
                            scale = min(max(scale * delta, 1), 4)
                        }
                        .onEnded { _ in
                            lastScale = 1.0
                            if scale < 1.0 {
                                withAnimation {
                                    scale = 1.0
                                }
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            if scale > 1 {
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            } else {
                                viewOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if scale > 1 {
                                lastOffset = offset
                            } else {
                                if abs(value.translation.height) > 100 {
                                    dismiss()
                                } else {
                                    withAnimation(.spring()) {
                                        viewOffset = 0
                                    }
                                }
                            }
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation {
                        if scale > 1 {
                            scale = 1.0
                            offset = .zero
                            lastOffset = .zero
                        } else {
                            scale = 3.0
                        }
                    }
                }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding([.top, .trailing], 16)
                }
                Spacer()
            }
        }
        .background(Color.black)
        .ignoresSafeArea()
        .statusBar(hidden: true)
    }
}

struct PaintingDetailView: View {
    let painting: Painting
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingWebSheet = false
    @State private var isShowingFullScreen = false
    
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
                    .onTapGesture {
                        isShowingFullScreen = true
                    }
                
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
        .fullScreenCover(isPresented: $isShowingFullScreen) {
            FullScreenImageView(url: painting.image_full_url_lg)
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
