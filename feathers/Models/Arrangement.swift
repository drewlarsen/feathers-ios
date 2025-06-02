import Foundation

struct ArrangementFeather: Codable {
    let id: String
    let pos: Int
    let flip: String
}

struct ArrangementCell: Codable {
    let feather_number: Int
    let position: Int
    let flip: String // enum: 'none', 'horizontal', 'vertical', 'both'
    let rotation: Int
}

struct Arrangement: Identifiable, Codable {
    let _id: String
    var id: String { _id }
    
    let number: Int
    let cols: Int
    let rows: Int
    let feathers: [ArrangementFeather]
    let is_composite: Bool
    let horizontal_spacing: Int
    let rotation: Int
    
    let designer_id: String
    
    let is_active: Bool
    let is_featured: Bool
    let has_current_images: Bool
    
    let print_item_ids: [String]
    
    let name: String?
    
    let etsy_mug_listing_id: Int?
    let is_etsy_composite_print_listing: Bool?
    let etsy_composite_listing_id: Int?
    
    let cells: [ArrangementCell]
    
    let createdAt: String
    let updatedAt: String
    
    // MARK: - Computed Properties
    
    var aspect_ratio: String {
        let ratio = Double(cols) / (Double(rows) * 2)
        
        var bestError = Double.infinity
        var bestNumerator = 0
        var bestDenominator = 1
        
        for d in 1...10 {
            let n = Int(round(ratio * Double(d)))
            let error = abs(ratio - Double(n) / Double(d))
            if error < bestError {
                bestError = error
                bestNumerator = n
                bestDenominator = d
            }
        }
        
        // If error is small enough, return fraction; otherwise, return decimal ratio
        return bestError < 0.05 ? "\(bestNumerator):\(bestDenominator)" : String(format: "%.2f:1", ratio)
    }
    
    private func numberPadded(digits: Int = 6) -> String {
        String(format: "%0\(digits)d", number)
    }
    
    private var filenamePrefix: String {
        "arr-\(numberPadded())"
    }
    
    var imageUrlLg: URL? {
        let urlString = Config.CDN.Paths.arrangements + "/\(filenamePrefix)_lg.webp"
        print("🔍 Large image URL: \(urlString)")
        return URL(string: urlString)
    }
    
    var imageUrlSm: URL? {
        let urlString = Config.CDN.Paths.arrangements + "/\(filenamePrefix)_sm.webp"
        print("🔍 Small image URL: \(urlString)")
        return URL(string: urlString)
    }
    
    var imageUrlPrint: URL? {
        let urlString = Config.CDN.Paths.arrangements + "/\(filenamePrefix)_print.webp"
        print("🔍 Print image URL: \(urlString)")
        return URL(string: urlString)
    }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case _id
        case number, cols, rows, feathers, is_composite, horizontal_spacing, rotation
        case designer_id, is_active, is_featured, has_current_images
        case print_item_ids, name, etsy_mug_listing_id
        case is_etsy_composite_print_listing, etsy_composite_listing_id
        case cells, createdAt, updatedAt
    }
} 