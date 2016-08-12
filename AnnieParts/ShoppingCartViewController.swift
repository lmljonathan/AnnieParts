//
//  ShoppingCartViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/20/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Presentr

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddProductModalView {

    @IBOutlet weak var tableView: UITableView!
    private var shoppingCart: [Product]!
    private var updatedItem = -1
    var viewFromNavButton = true;
    override func viewDidLoad() {
        self.navigationController?.addSideMenuButton()
        if (self.viewFromNavButton) {
            self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(title: "Back", style: .Plain, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
            viewFromNavButton = false
        } else {
            
            if self.navigationItem.leftBarButtonItems?.count == 3 {
                self.navigationItem.leftBarButtonItems?.removeAtIndex(0)
            }
        }
        if self.shoppingCart == nil {
            self.shoppingCart = []
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        MySingleton.sharedInstance.configureTableViewScroll(self.tableView)
        //loadData()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        get_json_data("shoppingCart", query_paramters: [:]) { (json) in
            if let products = json!["shopping_cart"] as? NSArray {
                for product in products {
                    let id = String(product["goods_id"] as! Int)
                    let name = product["goods_name"] as! String
                    let img = product["goods_img"] as! String
                    self.shoppingCart.append(Product(productID: id, productName: name, image: img))
                }
                self.tableView.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingCart.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shoppingCartCell") as! ShoppingCartCell
        cell.configureCell()
        cell.changeQuantityButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.changeQuantityButton.addTarget(self, action: #selector(ShoppingCartViewController.editItemQuantity(_:)), forControlEvents: .TouchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(ShoppingCartViewController.deleteItemFromCart(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
    @IBAction func editItemQuantity(sender: UIButton) {
        self.updatedItem = sender.tag
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("popup") as! AddProductModalViewController
        vc.delegate = self
        
        vc.id = self.shoppingCart[sender.tag].productID
        vc.buttonString = "Update"
        
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    @IBAction func deleteItemFromCart(sender:UIButton) {
        // may have to change productID to recordID????
        send_request("deleteFromCart", query_paramters: ["rec_id": self.shoppingCart[sender.tag].productID])
        self.shoppingCart.removeAtIndex(sender.tag)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request("addToCart", query_paramters: ["id": id, "cnt": quantity, "act": "set"])
        if (self.updatedItem != -1) {
            // update the table view data
        }
        self.tableView.reloadData()
    }
}
