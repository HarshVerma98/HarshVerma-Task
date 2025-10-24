//
//  HoldingsRepository.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


protocol HoldingsRepository {
    func fetchHoldings(completion: @escaping (Result<[Holding], NetworkError>) -> Void)
}
