import Foundation

enum Config {
    enum API {
        static let baseURL = "https://www.shaynalarsen.art/api"
    }
    
    enum CDN {
        static let baseURL = "https://smilingbear.nyc3.cdn.digitaloceanspaces.com"
        
        enum Paths {
            static let feathers = baseURL + "/public/images/feathers/paintings"
            static let arrangements = baseURL + "/public/images/arrangements/paintings"
            static let spirits = baseURL + "/public/images/spirits/paintings"
        }
    }
    
    enum Website {
        static let baseURL = "https://www.shaynalarsen.art"
        
        static func featherURL(_ urlPath: String) -> URL? {
            URL(string: "\(baseURL)/feathers/\(urlPath)")
        }
        
        static func spiritURL(_ id: String) -> URL? {
            URL(string: "\(baseURL)/spirits/\(id)")
        }
        
        static func arrangementURL(_ id: String) -> URL? {
            URL(string: "\(baseURL)/arrangements/\(id)")
        }
    }
} 