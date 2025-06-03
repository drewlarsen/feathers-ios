import Foundation

protocol Painting {
    var collectionName: String { get }
    var displayTitle: String { get }
    var dimensions: String { get }
    var priceDisplay: String { get }
    var description: String? { get }
    var imageUrlLg: URL? { get }
    var imageUrlSm: URL? { get }
    var webUrl: URL? { get }
    var shareText: String { get }
}

// Default implementation for shareText
extension Painting {
    var shareText: String {
        "Check out this beautiful \(collectionName.dropLast()) painting by Shayna Larsen!"
    }
} 