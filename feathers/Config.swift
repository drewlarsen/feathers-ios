import Foundation

enum Config {
    enum API {
        static let baseURL = "https://www.shaynalarsen.art/api"
    }
    
    enum CDN {
        static let baseURL = "https://smilingbear.nyc3.cdn.digitaloceanspaces.com/public/images"
        
        enum Paths {
            static let feathers = baseURL + "/feathers/paintings"
            static let arrangements = baseURL + "/arrangements"
        }
    }
} 