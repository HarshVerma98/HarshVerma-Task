//
//  HoldingsViewModelTests.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//

import XCTest
@testable import HarshVerma_Task

final class HoldingsViewModelTests: XCTestCase {

    var viewModel: HoldingsViewModel!
    var mockRepo: MockHoldingsRepository!
    var mockDelegate: MockDelegate!
    
    override func setUpWithError() throws {
        mockRepo = MockHoldingsRepository()
        viewModel = HoldingsViewModel(repository: mockRepo)
    }

    func testToggleExpansion() {
        mockDelegate = MockDelegate(onUpdate: {}, onError: { _ in })
           viewModel.delegate = mockDelegate

           viewModel.toggleExpansion(at: 0)
           XCTAssertTrue(viewModel.isExpanded(0))

           viewModel.toggleExpansion(at: 0)
           XCTAssertFalse(viewModel.isExpanded(0))
    }

    func testPortfolioSummaryCalculations() {

        mockRepo.mockHoldings = [
            Holding(symbol: "MAHABANK", quantity: 990, averagePrice: 35, close: 40, ltp: 38.05),
            Holding(symbol: "SBI", quantity: 150, averagePrice: 501, close: 590, ltp: 118.25)
           ]
           
        let expectedCurrentValue: Double = (38.05 * 990) + (118.25 * 150)
        let expectedTotalInvestment: Double = (35.0 * 990.0) + (501.0 * 150.0)
        let expectedTodaysPNL: Double = ((40.0 - 38.05) * 990.0) + ((590.0 - 118.25) * 150.0)
        let expectedTotalPNL: Double = expectedCurrentValue - expectedTotalInvestment
        let exp = expectation(description: "Portfolio summary calculation completed")
           
        let mockDelegate = MockDelegate(onUpdate: { [weak self] in
                guard let self = self else { return }

                let summary = self.viewModel.summary
            XCTAssertEqual(summary.currentValue, Double(expectedCurrentValue), accuracy: 0.01)
            XCTAssertEqual(summary.totalInvestment, Double(expectedTotalInvestment), accuracy: 0.01)
            XCTAssertEqual(summary.todaysPNL, Double(expectedTodaysPNL), accuracy: 0.01)
            XCTAssertEqual(summary.totalPNL, Double(expectedTotalPNL), accuracy: 0.01)

                exp.fulfill()
            }, onError: { error in
                XCTFail("Expected success but got error: \(error)")
                exp.fulfill()
            })
        
        viewModel.delegate = mockDelegate
        viewModel.fetchData()
        wait(for: [exp], timeout: 2.5)
    }

    func testDecodingHoldingsResponse() throws {
        let json = """
        {
          "data": {
            "userHolding": [
              {
                "symbol": "MAHABANK",
                "quantity": 990,
                "avgPrice": 35,
                "close": 40,
                "ltp": 38.05
              }
            ]
          }
        }
        """.data(using: .utf8)!
        
        let decoded = try JSONDecoder().decode(HoldingsResponse.self, from: json)
        XCTAssertEqual(decoded.data.userHolding.first?.symbol, "MAHABANK")
        XCTAssertEqual(decoded.data.userHolding.first?.ltp, 38.05)
    }

    func testNetworkFailureCase() {
        mockRepo.shouldFail = true
        let exp = expectation(description: "Network fails")
        
        mockRepo.fetchHoldings { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("Should have failed")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
