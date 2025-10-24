//
//  HoldingsCell.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import UIKit

class HoldingsCell: UITableViewCell {
    static let reuseIdentifier = "HoldingsCell"

    // MARK: - Subviews
    private let container = UIView()
    
    private let nameLabel = UILabel()
    private let qtyLabel = UILabel()

    private let ltpTitleLabel = UILabel()
    private let ltpValueLabel = UILabel()

    private let pnlTitleLabel = UILabel()
    private let pnlValueLabel = UILabel()

    private let topSeparator = UIView()
    private let bottomSeparator = UIView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Configure
    func configure(with holding: Holding) {
        nameLabel.text = holding.symbol.uppercased()
        qtyLabel.text = "Net Qty: \(holding.quantity.formattedQuantity())"

        ltpValueLabel.text = holding.ltp.formattedCurrency()

        // Per-holding today's P&L (ltp - close) * qty
        let todaysPnLForHolding = (holding.ltp - holding.close) * holding.quantity
        pnlValueLabel.text = todaysPnLForHolding.formattedCurrency()
        pnlValueLabel.textColor = todaysPnLForHolding >= 0 ? .systemGreen : .systemRed
    }
}

// MARK: - Private Setup
private extension HoldingsCell {

    func setupUI() {
        setupBaseAppearance()
        setupContainerView()
        setupLabels()
        setupStackLayout()
        setupSeparators()
    }

    func setupBaseAppearance() {
        selectionStyle = .none
        backgroundColor = .white
        contentView.backgroundColor = .clear
    }

    func setupContainerView() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = true
        contentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func setupLabels() {
        // Left side
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 1

        qtyLabel.font = .systemFont(ofSize: 13)
        qtyLabel.textColor = .secondaryLabel
        qtyLabel.numberOfLines = 1

        // Right side (titles)
        ltpTitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        ltpTitleLabel.textColor = .secondaryLabel
        ltpTitleLabel.text = "LTP:"

        pnlTitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        pnlTitleLabel.textColor = .secondaryLabel
        pnlTitleLabel.text = "P&L:"

        // Right side (values)
        ltpValueLabel.font = .systemFont(ofSize: 16)
        ltpValueLabel.textColor = .label
        ltpValueLabel.textAlignment = .right

        pnlValueLabel.font = .systemFont(ofSize: 13)
        pnlValueLabel.textColor = .label
        pnlValueLabel.textAlignment = .right
    }

    func setupStackLayout() {
        // Left stack (Stock name + quantity)
        let leftStack = UIStackView(arrangedSubviews: [nameLabel, qtyLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 4

        // Right top (LTP: Price)
        let ltpStack = UIStackView(arrangedSubviews: [ltpTitleLabel, ltpValueLabel])
        ltpStack.axis = .horizontal
        ltpStack.spacing = 4

        // Right bottom (P&L: Price)
        let pnlStack = UIStackView(arrangedSubviews: [pnlTitleLabel, pnlValueLabel])
        pnlStack.axis = .horizontal
        pnlStack.spacing = 4

        // Right side vertical stack
        let rightStack = UIStackView(arrangedSubviews: [ltpStack, pnlStack])
        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .trailing

        // Main horizontal row: left + right
        let mainStack = UIStackView(arrangedSubviews: [leftStack, rightStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }

    func setupSeparators() {
        [topSeparator, bottomSeparator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .separator
            container.addSubview($0)
        }

        NSLayoutConstraint.activate([
            topSeparator.topAnchor.constraint(equalTo: container.topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            topSeparator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            topSeparator.heightAnchor.constraint(equalToConstant: 1 / traitCollection.displayScale),

            bottomSeparator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            bottomSeparator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            bottomSeparator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1 / traitCollection.displayScale)
        ])

        topSeparator.isHidden = true
    }
}

#if DEBUG
extension HoldingsCell {
    var nameLabelText: String? { nameLabel.text }
    var qtyLabelText: String? { qtyLabel.text }
    var ltpValueText: String? { ltpValueLabel.text }
    var pnlValueText: String? { pnlValueLabel.text }
    var pnlValueColor: UIColor { pnlValueLabel.textColor }
}
#endif
