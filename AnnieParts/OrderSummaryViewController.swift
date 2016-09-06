//
//  OrderSummaryViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 9/6/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class OrderSummaryViewController: UIViewController {

    @IBOutlet weak var summaryTableView: UITableView!
    @IBOutlet weak var totalQuantity: UILabel!
    @IBOutlet weak var totalPrice: UILabel!

    var cartItems: [ShoppingCart]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summaryTableView.delegate = self
        self.summaryTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.summaryTableView.dequeueReusableCellWithIdentifier("summaryItem") as! OrderSummaryTableViewCell
        return cell
    }
}
