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
    private let infoView = InfoView()
    private let emptyMessageView = AnimatedMessageView()

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToNotification()
        let zipCode = UserDefaults.standard.string(forKey: ConfigurationView.zipCodeKey) ?? ""
        let selected = (UserDefaults.standard.array(forKey: DeviceSelectionViewModel.selectedDevicesKey) as? [String]) ?? []
        if zipCode.isEmpty == true || selected.isEmpty == true {
            settingsButtonAction()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromNotification()
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
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        infoView
    }
}
// MARK: - Private methods
private extension ResultsViewController {
    func setupViews() {
        setupNavigationBar()
        view.addSubview(tableView)
        view.addSubview(emptyMessageView)
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AvailableResultCell.self, forCellReuseIdentifier: AvailableResultCell.identifier)
        tableView.sectionHeaderTopPadding = 0
        emptyMessageView.update(
            animationName: WatchDogAnimation.walkingDog,
            title: "We are looking for you desired models",
            subtitle: "Make sure you keep the app open and your internet connection is working"
        )
    }

    func setupNavigationBar() {
        navigationItem.title = "Models Monitor"
        navigationController?.navigationBar.prefersLargeTitles = true
        if let historyImage = UIImage(named: "history_nav_bar") {
            let historyButton = UIBarButtonItem.imageButton(image: historyImage, color: .label) { [weak self] in
                self?.historyButtonAction()
            }
            navigationItem.rightBarButtonItems = [historyButton]
        }
        if let settingsImage = UIImage(named: "gear_nav_bar") {
            let settingsButton = UIBarButtonItem.imageButton(image: settingsImage, color: .label) { [weak self] in
                self?.settingsButtonAction()
            }
            navigationItem.rightBarButtonItems?.append(settingsButton)
        }
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

        viewModel.notifyAvailable = { models in
            print("found available: \(models)")
        }

        viewModel.updateInfo = { [infoView] info in
            DispatchQueue.main.async {
                infoView.update(info: info)
            }
        }
    }

    @objc func historyButtonAction() {
        let historyController = HistoryViewController()
        navigationController?.present(UINavigationController(rootViewController: historyController), animated: true)
    }

    func settingsButtonAction() {
        let configurationController = ConfigurationViewController()
        navigationController?.present(UINavigationController(rootViewController: configurationController), animated: true)
    }

    private func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleConfigurationTextChange), name: .configurationTextChanged, object: nil)
    }

    private func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self, name: .configurationTextChanged, object: nil)
    }

    @objc private func handleConfigurationTextChange() {
        viewModel.configurationChanged()
    }
}
