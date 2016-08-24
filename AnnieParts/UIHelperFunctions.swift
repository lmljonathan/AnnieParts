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
    sender.tableFooterView = UIView(frame: CGRectZero)
}
func configureNavBarBackButton(sender: UINavigationController, navItem: UINavigationItem) {
    sender.addSideMenuButton()
    let backButton = UIBarButtonItem(image: UIImage(named: CONSTANTS.IMAGES.BACK_BUTTON), style: .Done, target: sender, action: #selector(sender.popViewControllerAnimated(_:)))
    backButton.imageInsets = UIEdgeInsetsMake(0, -5.0, 0, -25.0)
//    navItem.leftBarButtonItems![0] = UIBarButtonItem(image: UIImage(named: CONSTANTS.IMAGES.BACK_BUTTON), style: .Done, target: sender, action: #selector(sender.popViewControllerAnimated(_:)))
    navItem.leftBarButtonItems?.insert(backButton, atIndex:0)
}
func removeNavBarBackButton(sender: UINavigationController, navItem: UINavigationItem) {
    sender.addSideMenuButton()
    if (navItem.leftBarButtonItems?.count == 3) {
        navItem.leftBarButtonItems?.removeAtIndex(0)
    }
}