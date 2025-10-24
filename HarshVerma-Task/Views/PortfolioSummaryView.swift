//
//  PortfolioSummaryViewDelegate.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//


import UIKit

protocol PortfolioSummaryViewDelegate: AnyObject {
    func portfolioSummaryViewDidToggle(_ view: PortfolioSummaryView, isExpanded: Bool)
}

class PortfolioSummaryView: UIView {

    weak var delegate: PortfolioSummaryViewDelegate?
    private(set) var isExpanded = false

    // MARK: - Subviews
    private let contentStack = UIStackView()
    private let separator = UIView()
    private let compactRow = UIStackView()

    // Expanded labels
    private let currentValueLabel = UILabel()
    private let totalInvestmentLabel = UILabel()
    private let todaysPNLLabel = UILabel()

    // Compact row
    private let compactTitleLabel = UILabel()
    private let compactChevron = UIImageView()
    private let compactValueLabel = UILabel()
    private let compactPercentLabel = UILabel()

    private let mainStack = UIStackView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        isExpanded = false
           contentStack.isHidden = true
           separator.isHidden = true
           compactChevron.transform = .identity
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addRoundedTopBorderToView(cornerRadius: 4)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }


    // MARK: - Configure
    func configure(with summary: PortfolioSummary, percentString: String? = nil) {
        currentValueLabel.text = summary.currentValue.formattedCurrency()
        totalInvestmentLabel.text = summary.totalInvestment.formattedCurrency()
        todaysPNLLabel.text = summary.todaysPNL.formattedCurrency()
        todaysPNLLabel.textColor = summary.todaysPNL >= 0 ? .systemGreen : .systemRed

        compactValueLabel.text = summary.totalPNL.formattedCurrency()
        compactValueLabel.textColor = summary.totalPNL >= 0 ? .systemGreen : .systemRed

        if let pct = percentString {
            compactPercentLabel.text = "(\(pct))"
            compactPercentLabel.textColor = compactValueLabel.textColor
            compactPercentLabel.isHidden = false
        } else {
            compactPercentLabel.isHidden = true
        }
    }
    
    func setExpanded(_ expand: Bool, animated: Bool) {
        guard expand != isExpanded else { return }
        isExpanded = expand

        let chevronRotation: CGAffineTransform = expand ? CGAffineTransform(rotationAngle: .pi) : .identity

        let changes = {
            self.contentStack.isHidden = !expand
            self.separator.isHidden = !expand
            self.compactChevron.transform = chevronRotation
            self.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.28, delay: 0, options: [.curveEaseInOut], animations: changes)
        } else {
            changes()
        }
    }
}

// MARK: - Extensions 
private extension PortfolioSummaryView {

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray

        setupLabels()
        setupExpandedContent()
        setupCompactRow()
        setupMainStack()
        setupGesture()
    }

    func setupLabels() {
        [currentValueLabel, totalInvestmentLabel, todaysPNLLabel,
         compactTitleLabel, compactValueLabel, compactPercentLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.numberOfLines = 1
        }

        compactTitleLabel.font = UIFont.systemFont(ofSize: 14)
        compactValueLabel.font = UIFont.boldSystemFont(ofSize: 14)
        compactValueLabel.textAlignment = .right
        compactPercentLabel.font = UIFont.systemFont(ofSize: 12)
        compactPercentLabel.textColor = .secondaryLabel
        compactPercentLabel.textAlignment = .right
    }
    
    func setupExpandedContent() {
        let currentRow = makeLeftRightRow(title: "Current value*", valueLabel: currentValueLabel)
        let investRow = makeLeftRightRow(title: "Total investment*", valueLabel: totalInvestmentLabel)
        let todayRow = makeLeftRightRow(title: "Today's Profit & Loss*", valueLabel: todaysPNLLabel)
        
        contentStack.axis = .vertical
        contentStack.spacing = 10
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(currentRow)
        contentStack.addArrangedSubview(investRow)
        contentStack.addArrangedSubview(todayRow)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemGray4
        separator.heightAnchor.constraint(equalToConstant: 1 / traitCollection.displayScale).isActive = true
        separator.isHidden = true
    }
    
    func makeLeftRightRow(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.textAlignment = .right
        let row = UIStackView(arrangedSubviews: [titleLabel, UIView(), valueLabel])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        return row
    }
    
    func setupCompactRow() {
        compactChevron.translatesAutoresizingMaskIntoConstraints = false
        compactChevron.contentMode = .scaleAspectFit
        compactChevron.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        compactChevron.tintColor = .label

        let chevronWidth = compactChevron.widthAnchor.constraint(equalToConstant: 14)
        let chevronHeight = compactChevron.heightAnchor.constraint(equalToConstant: 14)
        chevronHeight.priority = .defaultHigh
        NSLayoutConstraint.activate([chevronWidth, chevronHeight])

        compactTitleLabel.text = "Profit & Loss*"

        let leftTitleStack = UIStackView(arrangedSubviews: [compactTitleLabel, compactChevron])
        leftTitleStack.axis = .horizontal
        leftTitleStack.spacing = 4
        leftTitleStack.alignment = .center

        let rightStack = UIStackView(arrangedSubviews: [compactValueLabel, compactPercentLabel])
        rightStack.axis = .horizontal
        rightStack.spacing = 4
        rightStack.alignment = .center

        compactRow.axis = .horizontal
        compactRow.alignment = .center
        compactRow.spacing = 8
        compactRow.translatesAutoresizingMaskIntoConstraints = false
        compactRow.addArrangedSubview(leftTitleStack)
        compactRow.addArrangedSubview(UIView())
        compactRow.addArrangedSubview(rightStack)
    }
    
    func setupMainStack() {
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(contentStack)
        mainStack.addArrangedSubview(separator)
        mainStack.addArrangedSubview(compactRow)

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Toggle
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc func handleTap() {
        setExpanded(!isExpanded, animated: true)
        delegate?.portfolioSummaryViewDidToggle(self, isExpanded: isExpanded)
    }
}
