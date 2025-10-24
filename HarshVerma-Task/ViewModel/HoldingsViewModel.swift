//
//  HoldingsViewModelDelegate.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import Foundation

protocol HoldingsViewModelDelegate: AnyObject {
    func didUpdateData()
    func didFailWithError(_ error: Error)
}

class HoldingsViewModel {
    private let repository: HoldingsRepository
    weak var delegate: HoldingsViewModelDelegate?
    
    private(set) var holdings: [Holding] = []
    private(set) var summary: PortfolioSummary = PortfolioSummary(
        currentValue: 0,
        totalInvestment: 0,
        totalPNL: 0,
        todaysPNL: 0
    )

    private(set) var expandedIndices: Set<Int> = []
    
    // MARK: - Init
    init(repository: HoldingsRepository) {
        self.repository = repository
    }

    func fetchData() {
        repository.fetchHoldings { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let holdings):
                    self.holdings = holdings
                    self.calculateSummary()
                    self.delegate?.didUpdateData()
                    
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }

    func numberOfRows() -> Int {
        holdings.count
    }
    
    func holding(at index: Int) -> Holding {
        holdings[index]
    }
    
    func isExpanded(_ index: Int) -> Bool {
        expandedIndices.contains(index)
    }
    
    func toggleExpansion(at index: Int) {
        if expandedIndices.contains(index) {
            expandedIndices.remove(index)
        } else {
            expandedIndices.insert(index)
        }
        delegate?.didUpdateData()
    }

}

// MARK: - Extension
private extension HoldingsViewModel {
    
    func calculateSummary() {
        var currentValue: Double = 0
        var totalInvestment: Double = 0
        var todaysPNL: Double = 0
        
        for holding in holdings {
            currentValue += holding.ltp * holding.quantity
            totalInvestment += holding.averagePrice * holding.quantity
            todaysPNL += (holding.close - holding.ltp) * holding.quantity
        }

        let totalPNL = currentValue - totalInvestment

        summary = PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPNL: totalPNL,
            todaysPNL: todaysPNL
        )
    }
}
