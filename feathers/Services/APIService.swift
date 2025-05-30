//
//  APIService.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//

import Foundation

// Wrapper for API response
private struct FeathersResponse: Codable {
    let success: Bool
    let message: String?
    let data: [Feather]
}

class APIService {
    static let shared = APIService()
    private init() {}

    func fetchFeathers(completion: @escaping (Result<[Feather], Error>) -> Void) {
        guard let url = URL(string: "https://www.shaynalarsen.art/api/feathers") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, err in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err)); return
                }
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse))); return
                }
                do {
                    // Use custom ISO8601 formatter with fractional seconds
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
                    let wrapper = try decoder.decode(FeathersResponse.self, from: data)
                    if wrapper.success {
                        completion(.success(wrapper.data))
                    } else {
                        let apiError = NSError(domain: "APIService", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: wrapper.message ?? "Unknown error"])
                        completion(.failure(apiError))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
