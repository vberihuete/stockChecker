//
//  HistoryViewController.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 08/10/2022.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController {
    private let viewModel = HistoryViewModel()
    private let tableView = UITableView()
    private let emptyMessageView = AnimatedMessageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        viewModel.viewDidLoad()
    }
}

// MARK: - TableView DataSource & Delegate
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: AvailableResultCell.identifier, for: indexPath) as? AvailableResultCell,
            let model = viewModel.model(at: indexPath)
        else {
            return UITableViewCell()
        }

        cell.update(model: model)
        return cell
    }
}
// MARK: - Private methods
private extension HistoryViewController {
    func setupViews() {
        setupNavigationBar()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(emptyMessageView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AvailableResultCell.self, forCellReuseIdentifier: AvailableResultCell.identifier)
        emptyMessageView.update(
            animationName: WatchDogAnimation.walkingDog,
            title: "We haven't found any of your models yet!",
            subtitle: "Make sure you keep the app open and your internet connection is working"
        )
    }

    func setupNavigationBar() {
        navigationItem.title = "Found history"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupConstraints() {
        tableView.pinToSuperview()
        emptyMessageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                emptyMessageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                emptyMessageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                emptyMessageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            ]
        )
    }

    func bindViewModel() {
        viewModel.reloadData = { [tableView, emptyMessageView, viewModel] in
            DispatchQueue.main.async {
                tableView.reloadData()
                    tableView.isHidden = viewModel.elements.isEmpty
                    emptyMessageView.isHidden = !viewModel.elements.isEmpty
            }
        }
    }
}
