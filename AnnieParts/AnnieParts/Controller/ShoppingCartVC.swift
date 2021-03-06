//
//  ShoppingCartVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/17/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import SwiftyUtils
import Presentr

class ShoppingCartVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var checkout_button: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet var dismissKeyboard: UITapGestureRecognizer!

    var products: [ShoppingProduct] = []
    var subtotal_amount: Double = 0
    var total_quantity: Int = 0
    var row_in_edit: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        if (RequestHandler.cart_refresh) {
            let loading = startActivityIndicator(view: self.view)
            shopping_cart_request { (success, products) in
                if (success) {
                    self.products = products
                    self.calculateSubtotal()
                    self.tableView.reloadDataInSection(section: 0)
                    RequestHandler.cart_refresh = false
                    loading.stopAnimating()
                }
                else {
                    performLogin(vc: self)
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        quantityTextField.resignFirstResponder()
        super.viewWillDisappear(true)
    }


    func configureTextField() {
        quantityTextField.delegate = self
        dismissKeyboard.delegate = self
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
        subtotal_amount = price_amount
        total_quantity = quantity

        if (User.sharedInstance.user_rank > 1) {
            subtotal.text = "Cart subtotal (\(quantity) items): \(price_amount.formattedPrice)"
        }
        else {
            subtotal.text = "Cart: \(quantity) item(s)"
        }

        updateCartBadge(tab: self.tabBarController!, total: quantity)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isKind(of: UIButton.self))! {
            return false
        }
        return true
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
        row_in_edit = index?.row
        tableView.beginUpdates()
        tableView.scrollToRow(at: index!, at: .top, animated: true)
        tableView.endUpdates()
        quantityTextField.becomeFirstResponder()
    }

    @IBAction func deleteItem(_ sender: UIButton) {
        sender.isEnabled = false
        quantityTextField.resignFirstResponder()

        let index = tableView.indexPathForRow(at: sender.convert(.zero, to: self.tableView))
        let shopping_cell = tableView.cellForRow(at: index!) as! ShoppingCartCell
        shopping_cell.loading.startAnimating()

        delete_product_from_cart_request(product_id: products[(index?.row)!].product_id) { (success) in
            if (success) {
                shopping_cell.loading.stopAnimating()
                self.products.remove(at: (index?.row)!)
                self.calculateSubtotal()
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [index!], with: .automatic)
                self.tableView.endUpdates()
            }
            else {
                sender.isEnabled = true
                print("ERROR - cannot delete product from cart, please try again")
            }
        }
    }

    @IBAction func editQuantityConfirmed(_ sender: UIButton) {
        if (!(quantityTextField.text?.isEmpty)!) {
            let new_quantity = Int(quantityTextField.text!)!
            if (new_quantity > 0) {
                quantityTextField.resignFirstResponder()
                update_cart_request(product_id: products[row_in_edit].product_id, new_quantity: new_quantity, completion: { (success) in
                    if (success) {
                        self.products[self.row_in_edit].updateQuantity(quantity: new_quantity)
                        self.calculateSubtotal()
                        self.tableView.reloadDataInSection(section: 0)
                        self.quantityTextField.text = ""
                    }
                })
            }
            else {
                sender.layer.shake()
            }
        }
    }

    @IBAction func checkout(_ sender: UIButton) {
        if (products.isEmpty) {
            return
        }
        var checkout_message: String
        if (User.sharedInstance.user_rank > 1) {
            checkout_message = "Cart subtotal: \(subtotal_amount.formattedPrice)"
        }
        else {
            checkout_message = "Cart: \(total_quantity) item(s)"
        }

        let presenter = Presentr(presentationType: .alert)
        var alertController: AlertViewController {
            let alertController = Presentr.alertViewController(title: "Checkout", body: checkout_message)
            let cancelAction = AlertAction(title: "Cancel", style: .cancel) { alert in
                print("CANCEL!!")
            }
            let okAction = AlertAction(title: "Confirm", style: .default) { alert in
                print("Confirmed")
                let loading = startActivityIndicator(view: self.view)
                checkout_request { (success, order_number) in
                    if (success) {
                            loading.stopAnimating()
                            self.products.removeAll()
                            self.tableView.reloadDataInSection(section: 0)
                            self.calculateSubtotal()

                            let presenter2 = Presentr(presentationType: .alert)
                            var alertController2: AlertViewController {
                                let alertController2 = Presentr.alertViewController(title: "Order Completed", body: "\(order_number)")
                                let okAction2 = AlertAction(title: "Okay", style: .default, handler: nil)
                                alertController2.addAction(okAction2)
                                return alertController2
                            }
                            self.customPresentViewController(presenter2, viewController: alertController2, animated: true, completion: nil)
                    }
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            return alertController
        }
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
    @IBAction func finishedEditingQuantity(_ sender: UITapGestureRecognizer) {
        quantityTextField.resignFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showProductDetail") {
            if let destination = segue.destination as? ProductDetailsVC {
                destination.product = sender as? Product
            }
        }
    }
}

extension ShoppingCartVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell", for: indexPath) as? ShoppingCartCell {
            let product = products[indexPath.row]
            cell.initialize(data: product)
            cell.quantityButton.addTarget(self, action: #selector(self.editItem(_:)), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(self.deleteItem(_:)), for: .touchUpInside)
            return cell
        }
        return ShoppingCartCell()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ShoppingCartCell {
            cell.loading.isHidden = false
            cell.loading.startAnimating()
            let item = products[indexPath.row]
            product_id_search_request(product_id: item.product_id) { (success, product) in
                if (success) {
                    self.performSegue(withIdentifier: "showProductDetail", sender: product)
                    cell.loading.stopAnimating()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
        }
    }
}
