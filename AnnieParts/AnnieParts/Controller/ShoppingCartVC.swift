//
//  ShoppingCartVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/17/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import SwiftyUtils

class ShoppingCartVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var checkout_button: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var quantityTextField: UITextField!

    var products: [ShoppingProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureTextField()

        let loading = startActivityIndicator(view: self.view)
        shopping_cart_request { (products) in
            self.products = products
            self.calculateSubtotal()
            self.tableView.reloadData()
            loading.stopAnimating()
        }
    }

    func configureTextField() {
        quantityTextField.delegate = self
        bottomBarView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(ShoppingCartVC.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ShoppingCartVC.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "ShoppingCartCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShoppingCartCell")
    }

    func calculateSubtotal() {
        var price_amount: Double = 0
        var quantity: Int = 0
        for item in products {
            quantity += item.quantity
            price_amount += (item.price * Double(item.quantity))
        }
        subtotal.text = "Cart Subtotal (\(quantity) items): \(price_amount.formattedPrice)"
    }

    func deleteItem(row: Int) {
        let id = products[row].product_id
        delete_product_from_cart_request(product_id: id, completion: { success in
            if (success) {
                self.products.remove(at: row)
            }
            else {
                print("ERROR DELETING PRODUCT")
            }
        })
    }

    func changeQuantityForItem(row: Int, new_quantity: Int) {
        let id = products[row].product_id
        update_cart_request(product_id: id, new_quantity: new_quantity, completion: { success in
            if (success) {
                // reload the view
            }
            else {
                print("ERROR DELETING PRODUCT")
            }
        })
    }

    func keyboardWillShow(notification: NSNotification) {
        bottomBarView.isHidden = false
        let userInfo = notification.userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        let difference = keyboardSize.height - (self.tabBarController?.tabBar.frame.height)!

        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.bottomBarView.frame.origin.y -= difference
            self.tableView.frame.size.height -= difference
        })
    }

    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        let difference = keyboardSize.height - (self.tabBarController?.tabBar.frame.height)!
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.bottomBarView.frame.origin.y += difference
            self.tableView.frame.size.height += difference
            self.bottomBarView.isHidden = true
        })
    }

    @IBAction func editItem(_ sender: UIButton) {
        let index = tableView.indexPathForRow(at: sender.convert(.zero, to: tableView))
        tableView.beginUpdates()
        tableView.scrollToRow(at: index!, at: .top, animated: true)
        tableView.endUpdates()
        quantityTextField.becomeFirstResponder()
    }

    @IBAction func deleteItem(_ sender: UIButton) {
        delete_product_from_cart_request(product_id: products[sender.tag].product_id) { (success) in
            if (success) {
                self.products.remove(at: sender.tag)
                let index = self.tableView.indexPathForRow(at: sender.convert(.zero, to: self.tableView))
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [index!], with: .automatic)
                self.tableView.endUpdates()
            }
            else {
                print("ERROR - cannot delete product from cart, please try again")
            }
        }
    }

    @IBAction func editQuantityConfirmed(_ sender: UIButton) {
        quantityTextField.resignFirstResponder()
    }

    @IBAction func checkout(_ sender: UIButton) {
        checkout_request { (order_number) in
            // present modal view
        }
    }
    @IBAction func finishedEditingQuantity(_ sender: UITapGestureRecognizer) {
        quantityTextField.resignFirstResponder()
    }
}

extension ShoppingCartVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.products.count)
        return self.products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell", for: indexPath) as? ShoppingCartCell {
            let product = products[indexPath.row]
            cell.initialize(data: product)
            cell.quantityButton.addTarget(self, action: #selector(self.editItem(_:)), for: .touchUpInside)
            cell.quantityButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(self.deleteItem(_:)), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.row
            return cell
        }
        return ShoppingCartCell()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
