//
//  Holding.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import Foundation

struct Holding: Codable {
    let symbol: String
    let quantity: Double
    let averagePrice: Double
    let close: Double
    let ltp: Double

    enum CodingKeys: String, CodingKey {
        case symbol, quantity
        case averagePrice = "avgPrice"
        case close, ltp
    }
}

struct HoldingsResponse: Codable {
    let data: InnerData

    struct InnerData: Codable {
        let userHolding: [Holding]
    }
}
