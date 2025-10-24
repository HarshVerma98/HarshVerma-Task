//
//  HoldingsCellTests.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//

import XCTest
@testable import HarshVerma_Task

final class HoldingsCellTests: XCTestCase {
    func testConfigureSetsLabelValues() {
        let cell = HoldingsCell()
        let holding = Holding(symbol: "MAHABANK", quantity: 990, averagePrice: 35, close: 40, ltp: 38.05)
        cell.configure(with: holding)

        XCTAssertEqual(cell.nameLabelText, "MAHABANK")
        XCTAssertEqual(cell.ltpValueText, holding.ltp.formattedCurrency())
        XCTAssertEqual(cell.pnlValueColor, .systemGreen)
    }
}
