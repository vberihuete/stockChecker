//
//  CellProtocol.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 06/10/2022.
//

import UIKit

//protocol Component: UIView, IdentifiableCell {
//    func update(model: ComponentModel)
//}
//
//protocol ComponentModel {
////    var view: Component
//    func dequeue(inTableView tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
//}

// MARK: - Identifiable
protocol IdentifiableCell {
    static var identifier: String { get }
}

extension IdentifiableCell {
    static var identifier: String {
        String(describing: self)
    }
}
