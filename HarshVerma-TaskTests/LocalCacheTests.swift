//
//  LocalCacheTests.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import XCTest
@testable import HarshVerma_Task

final class LocalCacheTests: XCTestCase {
    func testSaveAndLoadHoldings() {
        let holdings = [
            Holding(symbol: "MAHABANK", quantity: 990, averagePrice: 35, close: 40, ltp: 38.05)
        ]
        CacheManager.shared.saveHoldings(holdings)
        let loaded = CacheManager.shared.loadHoldings()
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.first?.symbol, "MAHABANK")

        CacheManager.shared.clearCache()
        XCTAssertNil(CacheManager.shared.loadHoldings())
    }
}
