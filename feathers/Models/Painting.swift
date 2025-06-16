import Foundation

protocol Painting {
    var collection_name: String { get }
    var display_title: String { get }
    var dimensions: String { get }
    var price_display: String { get }
    var description: String? { get }
    var image_full_url_lg: URL? { get }
    var image_full_url_sm: URL? { get }
    var web_url: URL? { get }
    var share_text: String { get }
    var is_original_available: Bool { get }
}

// Default implementation for shareText
extension Painting {
    var share_text: String {
        "Check out this beautiful \(collection_name.dropLast()) painting by Shayna Larsen!"
    }
    
    // Default implementation for arrangements which are always available
    var is_original_available: Bool {
        true
    }
} 
