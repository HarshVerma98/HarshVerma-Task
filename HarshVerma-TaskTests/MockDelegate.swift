//
//  MockDelegate.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import Foundation
@testable import HarshVerma_Task

final class MockDelegate: HoldingsViewModelDelegate {
    private let onUpdate: () -> Void
    private let onError: (Error) -> Void

    init(onUpdate: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        self.onUpdate = onUpdate
        self.onError = onError
    }

    func didUpdateData() {
        onUpdate()
    }

    func didFailWithError(_ error: Error) {
        onError(error)
    }
}
