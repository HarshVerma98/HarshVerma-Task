//
//  Double+Extension.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import Foundation

extension Double {
    func formattedCurrency() -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        f.currencySymbol = "\u{20B9}"
        return f.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }

    func formattedQuantity() -> String {
        if floor(self) == self {
            return String(format: "%.0f", self)
        } else {
            return String(format: "%.2f", self)
        }
    }
}

