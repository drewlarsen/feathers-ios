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
    
    // MARK: - Private Methods
    
    private func fetch<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: Config.API.baseURL + endpoint) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let response = try self?.decoder.decode(APIResponse<T>.self, from: data)
                    if let response = response {
                        if response.success {
                            completion(.success(response.data))
                        } else {
                            let apiError = NSError(domain: "APIService", 
                                                 code: -1,
                                                 userInfo: [NSLocalizedDescriptionKey: response.message ?? "Unknown error"])
                            completion(.failure(apiError))
                        }
                    }
                } catch {
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
