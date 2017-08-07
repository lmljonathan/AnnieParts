//
//  LaunchVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/7/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureIDS { (success) in
            if (success) {
                let search = self.storyboard?.instantiateViewController(withIdentifier: "TabVC") as! UITabBarController
                self.present(search, animated: true, completion: nil)

                let user = User.sharedInstance
                let defaults = UserDefaults.standard
                user.username = defaults.string(forKey: "username")!
                user.user_rank = defaults.integer(forKey: "user_rank")
                user.company_name = defaults.string(forKey: "company")!
                user.shopping_count = defaults.integer(forKey: "shopping_count")

                search.tabBar.items![2].badgeValue = "\(user.shopping_count)"
            }
            else {
                performLogin(vc: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
