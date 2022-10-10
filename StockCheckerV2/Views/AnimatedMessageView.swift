//
//  AnimatedMessage.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 09/10/2022.
//

import Foundation
import UIKit
import Lottie

class AnimatedMessageView: UIStackView {
    let animationView: AnimationView = AnimationView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupHierarchy()
        setupConstraints()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }

    func update(animationName: String, title: String, subtitle: String? = nil) {
        animationView.animation = Animation.named(animationName)
        titleLabel.text = title
        subtitleLabel.isHidden = subtitle == nil
        subtitleLabel.text = subtitle
        animationView.play()
        animationView.loopMode = .loop
    }
}

private extension AnimatedMessageView {
    func setupViews() {
        axis = .vertical
        spacing = 10
        titleLabel.numberOfLines = 0
        subtitleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
    }

    func setupHierarchy() {
        addArrangedSubview(animationView)
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
    }

    func setupConstraints() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
