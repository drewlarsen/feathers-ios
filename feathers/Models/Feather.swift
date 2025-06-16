//
//  Feather.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import Foundation

struct Feather: Identifiable, Codable, Painting {
    var id: Int { number }
    
    let slug: String
    let number: Int
    let name: String?
    let is_name_generated: Bool
    let original_painted_date: String?
    let year: String?
    let collection_name: String
    let is_active: Bool
    let description: String?
    let bird_slug: String?
    let dimensions: String
    let height: Double
    let width: Double
    let orientation: String
    let paper: String
    let mount: String
    let pigment: String?
    let adornment: String?
    let is_print_available: Bool
    let is_original_available: Bool
    let rawPrice: String?
    let image_width: Int
    let image_height: Int
    let etsy_print_listing_id: Int?
    let etsy_original_listing_id: Int?
    
    let histogram: [Double]?
    let complementary_histogram: [Double]?
    let triad_1_histogram: [Double]?
    let triad_2_histogram: [Double]?
    
    let dark_color_hex: String?
    let dark_color_rgb: String?
    let light_color_hex: String?
    let light_color_rgb: String?
    let symbol_ids: [String]
    let similar_feather_ids: [String]
    let complementary_feather_ids: [String]
    let triad_1_feather_ids: [String]
    let triad_2_feather_ids: [String]
    let palette_distances: [Double]
    
    let image_url_sm: String
    let image_url_lg: String
    
    // MARK: - Painting Protocol Conformance
    
    var display_title: String { "Feather #\(number)" }
    
    var price_display: String { "$225" }
    
    var web_url: URL? {
        Config.Website.featherURL(urlPath)
    }
    
    var image_full_url_sm: URL? {
        let filename = self.image_url_sm.hasSuffix(".jpeg") ? self.image_url_sm : self.image_url_sm.replacingOccurrences(of: ".webp", with: ".jpeg")
        return URL(string: Config.CDN.Paths.feathers + "/\(filename)")
    }
    
    var image_full_url_lg: URL? {
        let filename = self.image_url_lg.hasSuffix(".jpeg") ? self.image_url_lg : self.image_url_lg.replacingOccurrences(of: ".webp", with: ".jpeg")
        return URL(string: Config.CDN.Paths.feathers + "/\(filename)")
    }
    
    // MARK: - Additional Properties
    
    let colors: [Color]
    let createdAt: String?
    let updatedAt: String?
    
    var nameAsTag: String {
        guard let name = name else { return String(number) }
        return name
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "  ", with: " ")
            .replacingOccurrences(of: " ", with: "-")
    }
    
    var urlPath: String {
        "\(number)-\(nameAsTag)"
    }
    
    struct Color: Codable {
        let population: Int
        let rgb: [Double]
        let rgb_string: String
        let hex: String
        let lightness: Double
        let hue: Double
        let names: [String: String]
    }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case slug, number, name, is_name_generated
        case original_painted_date, year, collection_name
        case is_active, description, bird_slug, dimensions
        case height, width, orientation, paper, mount
        case pigment, adornment, is_print_available
        case is_original_available, rawPrice = "price"
        case image_width, image_height
        case etsy_print_listing_id, etsy_original_listing_id
        case histogram, complementary_histogram
        case triad_1_histogram, triad_2_histogram
        case dark_color_hex, dark_color_rgb
        case light_color_hex, light_color_rgb
        case symbol_ids, similar_feather_ids
        case complementary_feather_ids
        case triad_1_feather_ids, triad_2_feather_ids
        case palette_distances
        case image_url_sm, image_url_lg
        case colors, createdAt, updatedAt
    }
}
