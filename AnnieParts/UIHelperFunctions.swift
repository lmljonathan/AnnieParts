//
//  ConfigureNav.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/12/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation
import UIKit
func configureTableView(sender: UITableView) {
    sender.delaysContentTouches = false
    for view in sender.subviews {
        if view is UIScrollView {
            (view as? UIScrollView)!.delaysContentTouches = false
            break
        }
    }
    sender.tableFooterView = UIView(frame: CGRect.zero)
}
func configureNavBarBackButton(sender: UINavigationController, navItem: UINavigationItem) {
    sender.addSideMenuButton()
    let backButton = UIBarButtonItem(image: UIImage(named: CONSTANTS.IMAGES.BACK_BUTTON), style: .done, target: sender, action: #selector(sender.popViewController))
    backButton.imageInsets = UIEdgeInsetsMake(0, -5.0, 0, -25.0)
    navItem.leftBarButtonItems?.insert(backButton, at:0)
}
func removeNavBarBackButton(sender: UINavigationController, navItem: UINavigationItem) {
    sender.addSideMenuButton()
    if (navItem.leftBarButtonItems?.count == 3) {
        navItem.leftBarButtonItems?.remove(at: 0)
    }
}
