//
//  SettingsVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/26/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var company_name: UILabel!
    @IBOutlet weak var rank: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = User.sharedInstance.username
        company_name.text = User.sharedInstance.company_name 
        switch User.sharedInstance.user_rank {
        case 1:
            rank.text = "浏览者"
        case 2:
            rank.text = "经销商（铜)"
        case 3:
            rank.text = "经销商（银)"
        case 4:
            rank.text = "经销商（金)"
        default:
            rank.text = "User"
        }
    }

    @IBAction func logout(_ sender: UIButton) {
        logout_request { (success) in
            if (success) {
                performLogin(vc: self)  
            }
            else {
                print("logout failed")
            }
        }
    }
}
