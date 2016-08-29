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
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet weak var serialNumber: UILabel!
    
    var name: String! = ""
    var id: String! = ""
    var sn: String! = "Serial Number"
    var delegate: AddProductModalView?
    var buttonString: String! = ""
    var quantity = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (buttonString == CONSTANTS.ADD_TO_CART_LABEL) {
            self.quantityTextField.becomeFirstResponder()
        }
        self.productName.text = self.name
        self.confirmButton.setTitle(self.buttonString, forState: .Normal)
        self.quantityTextField.text = String(quantity)
        self.serialNumber.text = sn

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
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
        if (self.quantity > 0) {
            self.delegate?.returnIDandQuantity(self.id, quantity: self.quantity)
        }
        let mainVC = self.presentingViewController
        
        self.dismissViewControllerAnimated(true) {
            if self.buttonString == "Update"{
                mainVC?.showNotificationView(CONSTANTS.UPDATED_QUANTITY_LABEL, image: UIImage(named: "checkmark")!, completion: { (vc) in
                    vc.delayDismiss(0.3)
                })
            }else{
                mainVC?.showNotificationView(CONSTANTS.ADDED_TO_CART_LABEL, image: UIImage(named: "checkmark")!, completion: { (vc) in
                    vc.delayDismiss(0.3)
                })
            }
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
