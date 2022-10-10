//
//  AvailableResultCell.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 05/10/2022.
//

import UIKit

final class AvailableResultCell: UITableViewCell, IdentifiableCell {
    private let container = UIStackView()
    private let leftContent = UIStackView()
    private let rightContent = UIStackView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let distance = UILabel()
    private let indicator = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(model: Model) {
        title.text = model.title
        subtitle.text = model.subtitle
        distance.text = model.distanceTitle
        indicator.backgroundColor = model.indicatorColor
        indicator.layer.borderColor = model.indicatorColor.cgColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

private extension AvailableResultCell {
    func setupViews() {
        let distanceContainer = UIStackView()
        distanceContainer.axis = .vertical
        distanceContainer.alignment = .trailing
        container.axis = .horizontal
        container.spacing = 8
        leftContent.axis = .vertical
        leftContent.spacing = 8
        rightContent.axis = .vertical
        rightContent.spacing = 8
        addSubview(container)
        container.addArrangedSubview(leftContent)
        container.addArrangedSubview(rightContent)

        // left container
        leftContent.addArrangedSubview(title)
        leftContent.addArrangedSubview(subtitle)

        title.font = UIFont.systemFont(ofSize: 18)
        subtitle.font = UIFont.systemFont(ofSize: 14)
        subtitle.numberOfLines = 0
        subtitle.textColor = .gray
        // right container
        rightContent.addArrangedSubview(distanceContainer)
        rightContent.addArrangedSubview(indicator)
        distanceContainer.addArrangedSubview(distance)
//        rightContent.alignment = .trailing
        distance.font = UIFont.systemFont(ofSize: 14)
        indicator.layer.cornerRadius = 8
        indicator.layer.borderWidth = 1
        indicator.layer.masksToBounds = true

    }

    func setupConstraints() {
        container.pinToSuperview(spacing: 10)
        rightContent.translatesAutoresizingMaskIntoConstraints = false
        rightContent.widthAnchor.constraint(equalToConstant: 100).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}

// MARK: - model
extension AvailableResultCell {
    struct Model {
        let title: String
        let subtitle: String
        let indicatorColor: UIColor
        let distanceTitle: String
    }
}
