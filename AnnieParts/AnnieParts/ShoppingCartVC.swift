//
//  ShoppingCartVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/17/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import SwiftyUtils

class ShoppingCartVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var checkout_button: UIButton!

    var products: [ShoppingProduct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        shopping_cart_request { (products) in
            self.products = products
            self.calculateSubtotal()
            self.tableView.reloadData()
        }
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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

    @IBAction func checkout(_ sender: UIButton) {
        checkout_request { (order_number) in
            // present modal view
        }
    }
}

extension ShoppingCartVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell", for: indexPath) as? ShoppingCartCell {
            let product = products[indexPath.row]
            cell.initialize(data: product)
            return cell
        }
        return ShoppingCartCell()
    }
}
