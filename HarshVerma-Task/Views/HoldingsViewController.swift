//
//  HoldingsViewController.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//

import UIKit

class HoldingsViewController: UIViewController {
    private let viewModel = HoldingsViewModel(repository: NetworkManager())
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let summaryView = PortfolioSummaryView()

    private var summaryCollapsedHeight: CGFloat = 70
    private var summaryExpandedHeight: CGFloat = 220
    private var summaryHeightConstraint: NSLayoutConstraint!
    
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Holdings"
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        setupTable()
        setupSummaryPanel()
        viewModel.fetchData()
    }
}

// MARK: - Extensions
private extension HoldingsViewController {
   
    func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HoldingsCell.self, forCellReuseIdentifier: HoldingsCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        refresh.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    func setupSummaryPanel() {
        view.addSubview(summaryView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleSummary))
        summaryView.addGestureRecognizer(tap)
        summaryHeightConstraint = summaryView.heightAnchor.constraint(equalToConstant: summaryCollapsedHeight)
        summaryHeightConstraint.priority = .required
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor),

            summaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            summaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            summaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            summaryHeightConstraint
        ])
    }

    @objc func toggleSummary() {
        let isNowExpanded = !summaryView.isExpanded

        summaryView.setExpanded(isNowExpanded, animated: true)
        summaryHeightConstraint.constant = isNowExpanded ? summaryExpandedHeight : summaryCollapsedHeight
        
        UIView.animate(withDuration: 0.28, delay: 0, options: [.curveEaseInOut]) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func refreshPulled() {
        CacheManager.shared.clearCache()
        viewModel.fetchData()
    }
}

// MARK: - Delegate Extension
extension HoldingsViewController: HoldingsViewModelDelegate {
    func didUpdateData() {
        summaryView.configure(with: viewModel.summary)
        tableView.reloadData()
        refresh.endRefreshing()
    }

    func didFailWithError(_ error: Error) {
        refresh.endRefreshing()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Extension Table View
extension HoldingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: HoldingsCell.reuseIdentifier, for: indexPath) as? HoldingsCell else {
            return UITableViewCell()
        }
        let holding = viewModel.holding(at: indexPath.row)
        cell.configure(with: holding)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
