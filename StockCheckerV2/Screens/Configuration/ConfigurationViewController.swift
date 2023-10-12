//
//  ConfigurationViewController.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 01/10/2023.
//

import Foundation
import SwiftUI

class ConfigurationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let configurationView = ConfigurationView()
        let hostingController = UIHostingController(rootView: configurationView)

        addChild(hostingController)
        view.addSubview(hostingController.view)

        // Adjust the frame as needed
        hostingController.view.frame = view.bounds

        hostingController.didMove(toParent: self)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
}
