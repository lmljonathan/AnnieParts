//
//  OrdersViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 9/6/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    
    enum OrderType {
        case Customer
        case Unprocessed
        case Processed
    }
    
    enum UserRank {
        case Browser
        case Dealer
    }

    @IBOutlet var ordersTableView: UITableView!
    
    var accountType: UserRank!
    var sectionTitles = ["Customer Orders", "Unprocessed Orders", "Processed Orders"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserRank()
        //self.loadData()
        self.ordersTableView.registerNib(UINib(nibName: "OrderCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL)
    }
    
    private func setUserRank() {
        if User.userRank == 1{
            accountType = .Browser
        }else{
            accountType = .Dealer
        }
    }
    
    private func loadData(){
        get_json_data(CONSTANTS.URL_INFO.OPTION_SEARCH, query_paramters: [:]) { (json) in
            
            if let customerOrderList = json![CONSTANTS.JSON_KEYS.CUSTOMER_ORDER_LIST] as? [[String: String]] {
                for order in customerOrderList {
                    print(order)
                    
                }
//                if (self.catalogData.count == 0) {
//                    self.noResultsFound = true
//                } else {
//                    self.noResultsFound = false
//                }
//                self.loadingIndicator.stopAnimating()
//                self.tableView.reloadDataWithAutoSizingCells()
                
            }
        }

    }

}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL, forIndexPath: indexPath) as! OrderTableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Perform segue to order list in future
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 117.0
    }
}
