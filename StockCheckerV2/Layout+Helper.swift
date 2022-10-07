//
//  Layout+Helper.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 06/10/2022.
//

import Foundation
import UIKit

extension UIView {
    func pinToSuperview(spacing: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: spacing),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: spacing * -1),
                topAnchor.constraint(equalTo: superview.topAnchor, constant: spacing),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: spacing * -1)
            ]
        )
    }
}
