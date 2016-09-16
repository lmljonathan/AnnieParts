//
//  CancelOrderViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 9/15/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class CancelOrderViewController: UIViewController {
    
    var row: Int!

    @IBAction func cancelButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
