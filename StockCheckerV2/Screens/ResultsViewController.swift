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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let model = viewModel.model(at: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = model.title
        config.secondaryText = model.subtitle
        cell.backgroundColor = model.color
        cell.contentConfiguration  = config
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleWatchDog()
    }
}
// MARK: - Private methods
private extension ResultsViewController {
    enum Constants {
        static let cellIdentifier = "cell-model-iphone"
    }
    func setupViews() {
        navigationItem.title = "Models Monitor"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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