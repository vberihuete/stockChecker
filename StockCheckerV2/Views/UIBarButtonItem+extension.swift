//
//  UIBarButtonItem+extension.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 08/10/2022.
//

import UIKit

extension UIBarButtonItem {
    static func imageButton(
        image: UIImage,
        size: CGFloat = 24,
        color: UIColor = .systemBackground,
        action: @escaping () -> Void
    ) -> UIBarButtonItem {
        // create ui button
        let button = UIButton(type: .system)
        // assign image
        button.setImage(image, for: .normal)
        button.tintColor = color
        // assign action
        button.addAction(.init(handler: { _ in action() }), for: .touchUpInside)
        // create menu bar item using custom view
        let menuBarItem = UIBarButtonItem(customView: button)
        //use auto layout to assign bar button's size
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size),
                menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size)
            ].compactMap { $0 }
        )
        return menuBarItem
    }
}

