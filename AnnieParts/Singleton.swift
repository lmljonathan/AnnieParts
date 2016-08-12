//
//  ConfigureNav.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/12/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation
import UIKit

class MySingleton: NSObject {
    static let sharedInstance = MySingleton()
    func configureTableViewScroll(sender: UITableView) {
        sender.delaysContentTouches = false
        for view in sender.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)!.delaysContentTouches = false
                break
            }
        }
    }
}