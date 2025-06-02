import SwiftUI

enum PaintingType {
    case spirit(Spirit)
    case feather(Feather)
    case arrangement(Arrangement)
    
    var collectionName: String {
        switch self {
        case .spirit: return "Mountain Spirits"
        case .feather: return "500 Feathers"
        case .arrangement: return "Arrangements"
        }
    }
    
    var displayTitle: String {
        switch self {
        case .spirit(let spirit): return "\"\(spirit.name)\""
        case .feather(let feather): return "Feather #\(feather.number)"
        case .arrangement(let arrangement): return "Arrangement #\(arrangement.number)"
        }
    }
    
    var dimensions: String {
        switch self {
        case .spirit(let spirit): return "\(spirit.width)\" × \(spirit.height)\""
        case .feather(let feather): 
            let width = Int(feather.width)
            let height = Int(feather.height)
            return "\(width)\" × \(height)\""
        case .arrangement(let arrangement): 
            let width = arrangement.cols * 5
            let height = arrangement.rows * 10
            return "\(width)\" × \(height)\""
        }
    }
    
    var price: String {
        switch self {
        case .spirit(let spirit): 
            if let price = spirit.price {
                return price.replacingOccurrences(of: "Optional(\"", with: "")
                         .replacingOccurrences(of: "\")", with: "")
            }
            return "Price on request"
        case .feather: return "$225"
        case .arrangement: return "$125"
        }
    }
    
    var description: String? {
        switch self {
        case .spirit(let spirit): return spirit.statement
        case .feather(let feather): return feather.description
        case .arrangement(let arrangement): 
            let featherNumbers = arrangement.feathers.map { String($0.id) }
            switch featherNumbers.count {
            case 0: return nil
            case 1: return "An arrangement of feather number \(featherNumbers[0])"
            case 2: return "An arrangement of feather numbers \(featherNumbers[0]) and \(featherNumbers[1])"
            default:
                let allButLast = featherNumbers.dropLast().joined(separator: ", ")
                let last = featherNumbers.last!
                return "An arrangement of feather numbers \(allButLast) & \(last)"
            }
        }
    }
    
    var imageUrl: URL? {
        switch self {
        case .spirit(let spirit): return spirit.imageUrlLg
        case .feather(let feather): return feather.imageUrlLg
        case .arrangement(let arrangement): return arrangement.imageUrlLg
        }
    }
    
    var webUrl: URL? {
        switch self {
        case .spirit(let spirit): return Config.Website.spiritURL(spirit.id)
        case .feather(let feather): return Config.Website.featherURL(feather.urlPath)
        case .arrangement(let arrangement): return Config.Website.arrangementURL(arrangement.id)
        }
    }
    
    var shareText: String {
        switch self {
        case .spirit(let spirit): 
            return "Check out this beautiful \(spirit.name) painting by Shayna Larsen!"
        case .feather:
            return "Check out this beautiful feather painting by Shayna Larsen!"
        case .arrangement:
            return "Check out this beautiful arrangement painting by Shayna Larsen!"
        }
    }
}

struct PaintingDetailView: View {
    let painting: PaintingType
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingWebSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Image
                AsyncImage(url: painting.imageUrl) { phase in
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
                .cornerRadius(8)
                .shadow(radius: 2, y: 1)
                .padding(.horizontal)
                
                // Title and Details
                VStack(alignment: .leading, spacing: 16) {
                    Text(painting.displayTitle)
                        .font(.system(size: 28, weight: .regular, design: .serif))
                    
                    Text("\(painting.dimensions) — \(painting.price)")
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
