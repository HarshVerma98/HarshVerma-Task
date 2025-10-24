//
//  MockHoldingsRepository.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import XCTest
@testable import HarshVerma_Task

class MockHoldingsRepository: HoldingsRepository {
    var shouldFail = false
    var mockError: NetworkError = .invalidURL
    var mockHoldings: [Holding] = [
        Holding(symbol: "TCS", quantity: 10, averagePrice: 3000, close: 3200, ltp: 3300),
        Holding(symbol: "INFY", quantity: 5, averagePrice: 1400, close: 1450, ltp: 1420)
    ]

    func fetchHoldings(completion: @escaping (Result<[Holding], NetworkError>) -> Void) {
        if shouldFail {
            completion(.failure(mockError))
        } else {
            completion(.success(mockHoldings))
        }
    }
}
