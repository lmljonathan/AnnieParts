//
//  AddProductModalViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/26/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

protocol AddProductModalView {
    func returnIDandQuantity(id: String, quantity: Int)
}
class AddProductModalViewController: UIViewController {

    var delegate: AddProductModalView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate?.returnIDandQuantity("hello", quantity: 21)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
