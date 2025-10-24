//
//  NetworkManagerTests.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//



import XCTest
@testable import HarshVerma_Task

final class NetworkManagerTests: XCTestCase {
    @MainActor func testOfflineFallbackLoadsCache() {
        let repo = NetworkManager()
        let mockHolding = Holding(symbol: "MAHABANK", quantity: 990, averagePrice: 35, close: 40, ltp: 38.05)
        CacheManager.shared.saveHoldings([mockHolding])

        let expectation = expectation(description: "Offline load")
        repo.fetchHoldings { result in
            switch result {
            case .success(let holdings):
                XCTAssertFalse(holdings.isEmpty)
                XCTAssertEqual(holdings.first?.symbol, "MAHABANK")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail in offline mode with cache")
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
