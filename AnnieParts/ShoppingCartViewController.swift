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
    var viewFromNavButton = true;
    override func viewDidLoad() {
        self.navigationController?.addSideMenuButton()
        if (self.viewFromNavButton) {
            self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(image: UIImage(named: "cart"), style: .Done, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
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
        loadData()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        print("loading data")
        get_json_data("shoppingCart", query_paramters: [:]) { (json) in
            if let products = json!["shopping_cart"] as? NSArray {
                for product in products {
                    let id = product["goods_id"] as! String
                    let name = product["goods_name"] as! String
                    //let img = product["goods_img"] as! String
                    //let startYear = String(product["start_time"] as! Int)
                    //let endYear = String(product["end_time"] as! Int)
                    let quantity = Int(product["goods_number"] as! String)
                    self.shoppingCart.append(ShoppingCart(productID: id, productName: name, image: "", startYear: "", endYear: "", quantity: quantity!))
                    self.shoppingCart.append(ShoppingCart(productID: id, productName: name, image: "", startYear: "", endYear: "", quantity: quantity!))
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
        let product = self.shoppingCart[indexPath.row]
        cell.productName.text = product.productName
        let url = NSURL(string: "http://www.annieparts.com/" + product.imagePath)!
        cell.loadImage(url)
        cell.changeQuantityButton.addTarget(self, action: #selector(ShoppingCartViewController.editItemQuantity(_:)), forControlEvents: .TouchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(ShoppingCartViewController.deleteItemFromCart(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
    @IBAction func editItemQuantity(sender: UIButton) {
        let index = self.tableView.indexPathForRowAtPoint(sender.convertPoint(CGPointZero, toView: self.tableView))
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("popup") as! AddProductModalViewController
        vc.delegate = self
        
        vc.id = self.shoppingCart[index!.row].productID
        vc.buttonString = "Update"
        
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
        self.tableView.reloadData()
    }
    @IBAction func deleteItemFromCart(sender:UIButton) {
        let index = self.tableView.indexPathForRowAtPoint(sender.convertPoint(CGPointZero, toView: self.tableView))
        send_request("deleteFromCart", query_paramters: ["goods_id": self.shoppingCart[index!.row].productID])
        self.shoppingCart.removeAtIndex(index!.row)
        
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([index!], withRowAnimation: .Fade)
        self.tableView.endUpdates()
        
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request("addToCart", query_paramters: ["id": id, "cnt": quantity, "act": "set"])
    }
}
