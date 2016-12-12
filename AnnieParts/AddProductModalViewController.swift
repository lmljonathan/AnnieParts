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

    @IBOutlet var modalView: UIView!
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
    var quantity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (buttonString == CONSTANTS.ADD_TO_CART_LABEL) {
            self.quantityTextField.becomeFirstResponder()
        }
        self.productName.text = self.name
        self.confirmButton.setTitle(self.buttonString, for: .normal)
        self.quantityTextField.text = String(quantity)
        self.serialNumber.text = sn
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let newRect = CGRect(x: self.modalView.frame.origin.x, y: self.modalView.frame.origin.y, width: self.modalView.frame.width, height: self.modalView.frame.height + self.productName.height - 23.0)
        self.modalView.frame = newRect
        self.modalView.addShadow(opacity: 0.2, offset: CGSize(width: 0, height: 5))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
    }
    
    @IBAction func numberInputChanged(_ sender: UITextField) {
        if (Int(sender.text!) != nil){
            self.quantity = Int(sender.text!)!
        } else {
            self.quantity = 0
        }
        print(self.quantity)
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if (self.quantity > 0) {
            self.delegate?.returnIDandQuantity(id: self.id, quantity: self.quantity)
            let mainVC = self.presentingViewController
            
            self.dismiss(animated: true) {
                if self.buttonString == "Update"{
                    mainVC?.showNotificationView(message: CONSTANTS.UPDATED_QUANTITY_LABEL, image: UIImage(named: "checkmark")!, completion: { (vc) in
                        vc.delayDismiss(seconds: 0.3)
                    })
                }else{
                    mainVC?.showNotificationView(message: CONSTANTS.ADDED_TO_CART_LABEL, image: UIImage(named: "checkmark")!, completion: { (vc) in
                        vc.delayDismiss(seconds: 0.3)
                    })
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
