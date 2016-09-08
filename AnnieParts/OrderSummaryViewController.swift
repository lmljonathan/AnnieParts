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

    var shoppingCart: [ShoppingCart]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return shoppingCart.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.ORDER_SUMMARY_CELL) as! OrderSummaryTableViewCell
        if (indexPath.row == shoppingCart.count) {
            cell.textLabel?.text = "TOTAL"
        }
        else {
            cell.textLabel?.text = self.shoppingCart[indexPath.row].productName
        }
        return cell
    }
}
