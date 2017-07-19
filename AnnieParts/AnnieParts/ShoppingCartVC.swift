//
//  ShoppingCartVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/17/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import SwiftyUtils

class ShoppingCartVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var checkout_button: UIButton!

    var products: [ShoppingProduct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shopping_cart_request { (products) in
            self.products = products
            self.calculateSubtotal()
            self.tableView.reloadData()
        }
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

    func deleteItem() {

    }

    func changeQuantityForItem() {

    }

    @IBAction func checkout(_ sender: UIButton) {
    }
}
