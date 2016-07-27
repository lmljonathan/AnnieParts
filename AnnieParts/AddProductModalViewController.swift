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

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    var name: String!
    var id: String!
    var delegate: AddProductModalView?
    private var quantity = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.name != nil) {
            self.productName.text = self.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberInputChanged(sender: UITextField) {
        if (Int(sender.text!) != nil){
            self.quantity = Int(sender.text!)!
        } else {
            self.quantity = 0
        }
        print(self.quantity)
    }
    @IBAction func addToCart(sender: UIButton) {
        self.delegate?.returnIDandQuantity(self.id, quantity: self.quantity)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel(sender: UIButton) {
        self.quantityTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
