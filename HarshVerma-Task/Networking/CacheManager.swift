//
//  CacheManager.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import Foundation

class CacheManager {
    static let shared = CacheManager()
    private init() {}

    private var cacheURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("holdings_cache.json")
    }

    func saveHoldings(_ holdings: [Holding]) {
        do {
            let data = try JSONEncoder().encode(holdings)
            try data.write(to: cacheURL, options: .atomic)
        } catch {
            print("Cache write error:", error)
        }
    }

    func loadHoldings() -> [Holding]? {
        do {
            let data = try Data(contentsOf: cacheURL)
            let holdings = try JSONDecoder().decode([Holding].self, from: data)
            return holdings
        } catch {
            print("Cache read error:", error)
            return nil
        }
    }

    func clearCache() {
        try? FileManager.default.removeItem(at: cacheURL)
    }
}
