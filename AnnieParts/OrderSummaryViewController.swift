//
//  OrderSummaryViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 9/7/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class OrderSummaryViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dismissButtonWidthConstraint: NSLayoutConstraint!

    private var totalQuantity: Int = 0
    private var totalPrice: Double = 0.0

    var shoppingCart: [ShoppingCart]! = []
    var orderID: String?
    var confirmActive: Bool! = true

    override func viewDidLoad() {
        super.viewDidLoad()
        if confirmActive == true{
            print("from orders")
            self.confirmButton.titleLabel?.numberOfLines = 2
            self.confirmButton.titleLabel?.textAlignment = .Center
            self.confirmButton.setTitle("Confirm Business Order", forState: .Normal)
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.totalQuantity = 0
        self.totalPrice = 0.0
        
        if orderID != nil{
            self.loadDataFromOrderID({
                self.tableView.reloadData()
            })
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if confirmActive == false {
            self.mainView.removeConstraint(self.dismissButtonWidthConstraint)
            self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
            
            let right = NSLayoutConstraint(item: self.cancelButton, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
            
            self.mainView.addConstraint(right)
            
            self.confirmButton.hidden = true
        }
    }
    
    @IBAction func submitOrder(sender: UIButton) {
        //add in http request
        send_request(CONSTANTS.URL_INFO.CHECKOUT, query_paramters: [:])
        self.performSegueWithIdentifier("unwindToCartWithConfirm", sender: self)
        // self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelCheckout(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func loadDataFromOrderID(completion: () -> Void){
        get_json_data(CONSTANTS.URL_INFO.ORDER_DETAIL, query_paramters: ["order_id": String(orderID!)]) { (json) in
            
            if let itemArray = json!["rlist"] as? [[String: String]]{
                if itemArray.count > 0{
            
                    for item in itemArray{
                        let name = item["goods_name"]!
                        let quantity = Int(item["quantity"]!)
                        let price = Double(item["unit_price"]!)
                        
                        let fullItem = ShoppingCart(productID: "", productName: name, image: "", serialNumber: "", startYear: "", endYear: "", brandID: -1, price: price!, quantity: quantity!, modelID: -1, modelIDlist: [])
                        
                        self.shoppingCart.append(fullItem)
                    }
                    completion()
                }else{
                    print("Error retrieving JSON for id \(self.orderID!) - no items")
                    completion()
                }
            }
            
        }

    }
    

}

extension OrderSummaryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCart.count + 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.ORDER_SUMMARY_CELL) as! OrderSummaryTableViewCell
        if (indexPath.row == 0) {
            cell.productName.text = "Product Name"
            cell.quantity.text = "Qty"
            cell.price.text = "Price"
        }
        else if (indexPath.row == shoppingCart.count + 1) {
            cell.productName.text = "TOTAL"
            cell.quantity.text = String(self.totalQuantity)
            cell.price.text = String(self.totalPrice)
        }
        else {
            let item = self.shoppingCart[indexPath.row-1]
            cell.productName.text = item.productName
            cell.quantity.text = String(item.quantity)
            cell.price.text = "$" + String(item.price)

            self.totalQuantity += item.quantity
            self.totalPrice += item.price * Double(item.quantity)
        }
        return cell
    }
}
