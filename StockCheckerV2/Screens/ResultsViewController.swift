//
//  ResultsViewController.swift
//  StockChecker
//
//  Created by Vincent Berihuete Paulino on 23/09/2022.
//

import UIKit

class ResultsViewController: UIViewController {
    private let viewModel = ResultsViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        viewModel.viewDidLoad()
        // https://www.apple.com/uk/shop/buy-iphone/iphone-14-pro/6.7-inch-display-128gb-gold [quick open]
        // https://www.apple.com/uk/shop/buy-iphone/iphone-14-pro/6.7-inch-display-128gb-space-black
        // https://www.apple.com/uk/shop/buy-iphone/iphone-14-pro/6.7-inch-display-128gb-silver
        // https://www.apple.com/uk/shop/buy-iphone/iphone-14-pro/6.7-inch-display-128gb-deep-purple
    }
}

// MARK: - TableView DataSource & Delegate
extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleWatchDog()
    }
}
// MARK: - Private methods
private extension ResultsViewController {
    func setupViews() {
        navigationItem.title = "Models Monitor"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AvailableResultCell.self, forCellReuseIdentifier: AvailableResultCell.identifier)
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

        viewModel.notifyAvailable = { models in
            print("found available: \(models)")
        }
    }
}
