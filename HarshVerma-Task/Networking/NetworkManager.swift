//
//  NetworkError.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//



import Foundation

enum NetworkError: Error {
    case invalidURL
    case transportError(Error)
    case decodingError(Error)
    case noCachedData
}

class NetworkManager: HoldingsRepository {

    private let baseURL = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
    
    func fetchHoldings(completion: @escaping (Result<[Holding], NetworkError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            // Background thread
            if let error = error {
                // Fallback to cache
                if let cached = CacheManager.shared.loadHoldings() {
                    Task { @MainActor in
                        completion(.success(cached))
                    }
                } else {
                    Task { @MainActor in
                        completion(.failure(.transportError(error)))
                    }
                }
                return
            }

            guard let data = data else {
                if let cached = CacheManager.shared.loadHoldings() {
                    Task { @MainActor in
                        completion(.success(cached))
                    }
                } else {
                    Task { @MainActor in
                        completion(.failure(.noCachedData))
                    }
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(HoldingsResponse.self, from: data)
                let holdings = response.data.userHolding

                CacheManager.shared.saveHoldings(holdings)
                Task { @MainActor in
                    completion(.success(holdings))
                }

            } catch {
                if let cached = CacheManager.shared.loadHoldings() {
                    Task { @MainActor in
                        completion(.success(cached))
                    }
                } else {
                    Task { @MainActor in
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
        }
        task.resume()
    }
}
