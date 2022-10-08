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
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AvailableResultCell.self, forCellReuseIdentifier: AvailableResultCell.identifier)
        tableView.contentInset = .init(top: 30, left: 0, bottom: 0, right: 0)
    }

    func setupNavigationBar() {
        navigationItem.title = "Found history"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupConstraints() {
        tableView.pinToSuperview()
    }

    func bindViewModel() {
        viewModel.reloadData = { [tableView] in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
}
