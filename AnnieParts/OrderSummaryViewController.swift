//
//  OrderSummaryViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 9/7/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
protocol OrderSummaryModalView {
    func confirmedShoppingCart(clear: Bool)
}
class OrderSummaryViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dismissButtonWidthConstraint: NSLayoutConstraint!

    fileprivate var totalQuantity: Int = 0
    fileprivate var totalPrice: Double = 0.0

    var shoppingCart: [ShoppingCart]! = []
    var orderID: String! = ""
    var row: Int? = nil
    var confirmActive: Bool! = true
    var delegate: OrderSummaryModalView?

    override func viewDidLoad() {
        super.viewDidLoad()
        if row != nil{
            print("from orders")
            self.confirmButton.titleLabel?.numberOfLines = 2
            self.confirmButton.titleLabel?.textAlignment = .center
            self.confirmButton.setTitle("Confirm Business Order", for: .normal)
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100

        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.totalQuantity = 0
        self.totalPrice = 0.0
        
        if orderID != ""{
            self.loadDataFromOrderID(completion: {
                self.tableView.reloadData()
            })
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if confirmActive == false {
            self.mainView.removeConstraint(self.dismissButtonWidthConstraint)
            self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
            
            let right = NSLayoutConstraint(item: self.cancelButton, attribute: NSLayoutAttribute.trailingMargin, relatedBy: NSLayoutRelation.equal, toItem: self.mainView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1, constant: 0)
            
            self.mainView.addConstraint(right)
            
            self.confirmButton.isHidden = true
        }
    }
    
    @IBAction func submitOrder(sender: UIButton) {
        //add in http request
        if row != nil{
            print("unwind to orders with confirm")
            self.performSegue(withIdentifier: "unwindToOrdersWithConfirm", sender: self)
        }else{
            print("Submit button")
            self.delegate?.confirmedShoppingCart(clear: true) 
            self.performSegue(withIdentifier: "unwindToCartWithConfirm", sender: self)
        }
    }
    
    @IBAction func cancelCheckout(sender: UIButton) {
        self.delegate?.confirmedShoppingCart(clear: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadDataFromOrderID(completion: @escaping () -> Void){
        get_json_data(query_type: CONSTANTS.URL_INFO.ORDER_DETAIL, query_paramters: ["order_id": String(orderID!) as AnyObject]) { (json) in
            
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCart.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CONSTANTS.CELL_IDENTIFIERS.ORDER_SUMMARY_CELL) as! OrderSummaryTableViewCell
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency

        if (indexPath.row == 0) {
            cell.productName.text = "Product Name"
            cell.quantity.text = "Qty"
            cell.price.text = "Price"
        }
        else if (indexPath.row == shoppingCart.count + 1) {
            cell.productName.text = "TOTAL"
            cell.quantity.text = String(self.totalQuantity)
            cell.price.text = formatter.string(from: NSNumber(value: self.totalPrice))!
        }
        else {
            let item = self.shoppingCart[indexPath.row-1]

            cell.productName.text = item.productName
            cell.quantity.text = String(item.quantity)
            cell.price.text = formatter.string(from: NSNumber(value: item.price))! 

            self.totalQuantity += item.quantity
            self.totalPrice += item.price * Double(item.quantity)
        }
        return cell
    }
}
