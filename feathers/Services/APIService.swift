//
//  APIService.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import Foundation

// Generic API Response wrapper
private struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T
}

class APIService {
    static let shared = APIService()
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchFeathers(completion: @escaping (Result<[Feather], Error>) -> Void) {
        fetch(endpoint: "/feathers", completion: completion)
    }
    
    func fetchArrangements(completion: @escaping (Result<[Arrangement], Error>) -> Void) {
        fetch(endpoint: "/arrangements", completion: completion)
    }
    
    func fetchSpirits(completion: @escaping (Result<[Spirit], Error>) -> Void) {
        fetch(endpoint: "/spirits", completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func fetch<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: Config.API.baseURL + endpoint) else {
            print("❌ APIService - Invalid URL: \(Config.API.baseURL + endpoint)")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ APIService - Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("❌ APIService - No data received")
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let response = try self?.decoder.decode(APIResponse<T>.self, from: data)
                    if let response = response {
                        if response.success {
                            completion(.success(response.data))
                        } else {
                            let message = response.message ?? "Unknown error"
                            print("❌ APIService - API returned error: \(message)")
                            let apiError = NSError(domain: "APIService", 
                                                 code: -1,
                                                 userInfo: [NSLocalizedDescriptionKey: message])
                            completion(.failure(apiError))
                        }
                    }
                } catch {
                    print("❌ APIService - Decoding error: \(error)")
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("Missing key: \(key.stringValue) - \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("Type mismatch: expected \(type) - \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("Value not found: expected \(type) - \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error: \(decodingError)")
                        }
                    }
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - JSON Decoder Setup
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()
}
