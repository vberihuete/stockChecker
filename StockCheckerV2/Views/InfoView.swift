//
//  InfoView.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 08/10/2022.
//

import Foundation
import UIKit

class InfoView: UIStackView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(info: String) {
        titleLabel.text = info
    }
}

private extension InfoView {
    func setupViews() {
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        backgroundColor = .systemBackground

        addArrangedSubview(titleLabel)
    }

    func setupConstraints() {
        titleLabel.pinToSuperview()
    }
}
