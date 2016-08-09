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
    @IBOutlet weak var confirmButton: UIButton!
    var name: String!
    var id: String!
    var delegate: AddProductModalView?
    var buttonString: String!
    var quantity = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.name != nil) {
            self.productName.text = self.name
        }
        if (self.buttonString != nil) {
            self.confirmButton.setTitle(self.buttonString, forState: .Normal)
        }
        self.quantityTextField.text = ""
        self.quantityTextField.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
