//
//  InputViewController.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 15/10/2022.
//

import Foundation
import UIKit

final class InputViewController: UIViewController {
    private let viewModel: ConfigViewModel
    private let container = UIStackView()
    private let titleMessage = AnimatedMessageView()
    private let continueButton = UIButton()

    init(viewModel: ConfigViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHierarchy()
        setupConstraints()
    }
}

private extension InputViewController {
    func setupHierarchy() {
        container.addArrangedSubview(titleMessage)
        container.addArrangedSubview(continueButton)
        view.addSubview(container)
    }
    func setupViews() {
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        container.spacing = 30
        container.axis = .vertical
        continueButton.configuration = .filled()
        continueButton.setTitle("Start", for: .normal)
        titleMessage.update(
            animationName: "typing-guy",
            title: "Let's config your Watch Dog",
            subtitle: """
                Watch dog let's you search and monitor for your top apple devices. We use some info to track down what you want hit start so we can gather it
            """
        )
    }

    func setupConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                continueButton.heightAnchor.constraint(equalToConstant: 40)
            ]
        )
    }

    func setupNavigationBar() {
        //        navigationItem.title = "Configure what"
        //        navigationController?.navigationBar.prefersLargeTitles = true
        }
