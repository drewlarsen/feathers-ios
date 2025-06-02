import Foundation

struct Spirit: Identifiable, Codable {
    let id: String
    let name: String
    let year: String
    let dimensions: String
    let width: Int
    let height: Int
    let print_ratio: String?
    let price: String?
    let paper: String?
    let mount: String?
    let is_original_available: Bool
    let statement: String?
    let orientation: String
    let gallery_image_sm: String
    let gallery_image_lg: String
    let print_no_sig_file: String?
    let secondary_images: [String]
    let pigment: String?
    let collection_name: String
    let are_prints_available: Bool?
    let signature_position_horizontal: Double
    
    // Computed properties for full image URLs
    var imageUrlSm: URL? {
        URL(string: Config.CDN.baseURL + gallery_image_sm)
    }
    
    var imageUrlLg: URL? {
        URL(string: Config.CDN.baseURL + gallery_image_lg)
    }
    
    var secondaryImageUrls: [URL] {
        secondary_images.compactMap { path in
            URL(string: Config.CDN.baseURL + path)
        }
    }
    
    var aspectRatio: CGFloat {
        CGFloat(width) / CGFloat(height)
    }
} 