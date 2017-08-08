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
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(colorLiteralRed: 20.0/255.0, green: 24.0/255.0, blue: 35.0/255.0, alpha: 1).cgColor, UIColor(colorLiteralRed: 53.0/255.0, green: 53.0/255.0, blue: 73.0/255.0, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        self.view.layer.addSublayer(gradient)
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
                configureTabBar(tab: search)
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
