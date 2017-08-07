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
