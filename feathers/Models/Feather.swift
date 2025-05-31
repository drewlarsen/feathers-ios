//
//  Feather.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import Foundation

struct Feather: Identifiable, Codable {
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
    let price: String?
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
    
    var imageUrlSm: URL? {
        let filename = image_url_sm.hasSuffix(".jpeg") ? image_url_sm : image_url_sm.replacingOccurrences(of: ".webp", with: ".jpeg")
        return URL(string: "https://smilingbear.nyc3.cdn.digitaloceanspaces.com/public/images/feathers/paintings/\(filename)")
    }
    var imageUrlLg: URL? {
        let filename = image_url_lg.hasSuffix(".jpeg") ? image_url_lg : image_url_lg.replacingOccurrences(of: ".webp", with: ".jpeg")
        return URL(string: "https://smilingbear.nyc3.cdn.digitaloceanspaces.com/public/images/feathers/paintings/\(filename)")
    }
    
    let colors: [Color]
    let createdAt: String?
    let updatedAt: String?
    
    struct Color: Codable {
        let population: Int
        let rgb: [Double]
        let rgb_string: String
        let hex: String
        let lightness: Double
        let hue: Double
        let names: [String: String]
    }
}
