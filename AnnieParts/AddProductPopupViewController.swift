//
//  AddProductPopupViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/18/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import PopupController

class AddProductPopupViewController: UIViewController, PopupContentViewController {

    @IBOutlet weak var productQuantity: UITextField!
    private var popupSize: CGSize!
    var closeHandler: (() -> Void)?
    
    private var quantity = 1
    var id_number: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSizeMake(200,200)
        self.popupSize = CGSizeMake(200,200)
        
        if (self.id_number == nil) {
            id_number = -1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instance() -> AddProductPopupViewController {
        return (UIStoryboard(name: "AddProductPopup", bundle: nil).instantiateInitialViewController() as! AddProductPopupViewController)
    }
    
    @IBAction func increaseQuantity(sender: UIButton) {
        self.quantity += 1
        self.productQuantity.text = String(self.quantity)
    }
    
    @IBAction func decreaseQuantity(sender: UIButton) {
        if (self.quantity > 1) {
            self.quantity -= 1
        }
        self.productQuantity.text = String(self.quantity)
    }
    @IBAction func userEnteredNumber(sender: UITextField) {
        print("hello")
        if (Int(sender.text!) != nil){
            self.quantity = Int(sender.text!)!
        } else {
            self.quantity = 1
        }
    }
    
    @IBAction func addProductToCart(sender: UIButton) {
        print(id_number)
        print("\(self.quantity) Items Added to cart")
        self.view.endEditing(true)
        closeHandler?()
    }
    @IBAction func cancel(sender: UIButton) {
        print("No items added")
        self.view.endEditing(true)
        closeHandler?()
    }
    // PopupContentViewController Protocol
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return popupSize
    }
}
