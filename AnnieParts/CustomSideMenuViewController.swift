//
//  CustomSideMenuViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/24/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import SideMenuController
class CustomSideMenuViewController: SideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        performSegueWithIdentifier("showCenterSearch", sender: nil)
        performSegueWithIdentifier("containSideMenu", sender: nil)
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
