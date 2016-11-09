//
//  OrderNumberVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 10/18/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class OrderNumberVC: UIViewController {

    @IBOutlet weak var order_sn: UILabel!
    var sn_label: String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.order_sn.text = sn_label
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
