//
//  OrderSummaryViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 9/7/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class OrderSummaryViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private var totalQuantity: Int = 0
    private var totalPrice: Double = 0.0

    var shoppingCart: [ShoppingCart]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.totalQuantity = 0
        self.totalPrice = 0.0


        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitOrder(sender: UIButton) {
        //add in http request
        send_request(CONSTANTS.URL_INFO.CHECKOUT, query_paramters: [:])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelCheckout(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
            self.totalPrice += item.price
        }
        return cell
    }
}
