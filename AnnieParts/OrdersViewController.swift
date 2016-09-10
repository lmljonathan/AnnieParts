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
    
    var customerOrders: [Order] = []
    var unprocessedOrders: [Order] = []
    var processedOrders: [ProcessedOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ordersTableView.registerNib(UINib(nibName: "OrderCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL)
        
        self.setUserRank()
        self.loadData {
            self.ordersTableView.reloadData()
        }
        
    }
    
    private func setUserRank() {
        if User.userRank == 1{
            accountType = .Browser
        }else{
            accountType = .Dealer
        }
    }
    
    private func loadData(completion: () -> Void){
        get_json_data(CONSTANTS.URL_INFO.OPTION_SEARCH, query_paramters: [:]) { (json) in
            
            // Customer Orders
            if let customerOrders = json![CONSTANTS.JSON_KEYS.CUSTOMER_ORDER_LIST] as? [[String: String]] {
                for order in customerOrders {
                    let addTime = order[CONSTANTS.JSON_KEYS.ADD_TIME]!
                    let userID = Int(order[CONSTANTS.JSON_KEYS.USER_ID]!)!
                    let orderID = Int(order[CONSTANTS.JSON_KEYS.ORDER_ID]!)!
                    let orderSN = order[CONSTANTS.JSON_KEYS.ORDER_SN]!
                    let totalPrice = Double(order[CONSTANTS.JSON_KEYS.TOTAL_PRICE]!)!
                    
                    self.customerOrders.append(Order(addTime: addTime, userID: userID, totalPrice: totalPrice, sn: orderSN, id: orderID))
                }
            }
            
            // Unprocessed Orders
            if let unprocessedOrders = json![CONSTANTS.JSON_KEYS.UNPROCESSED_ORDER_LIST] as? [[String: String]]{
                for order in unprocessedOrders{
                    let addTime = order[CONSTANTS.JSON_KEYS.ADD_TIME]!
                    let userID = Int(order[CONSTANTS.JSON_KEYS.USER_ID]!)!
                    let orderID = Int(order[CONSTANTS.JSON_KEYS.ORDER_ID]!)!
                    let orderSN = order[CONSTANTS.JSON_KEYS.ORDER_SN]!
                    let totalPrice = Double(order[CONSTANTS.JSON_KEYS.TOTAL_PRICE]!)!
                    
                    self.customerOrders.append(Order(addTime: addTime, userID: userID, totalPrice: totalPrice, sn: orderSN, id: orderID))
                }
                
            }
            
            // Processed Order
            if let processedOrders = json![CONSTANTS.JSON_KEYS.PROCESSED_ORDER_LIST] as? [[String: String]]{
                for order in processedOrders{
                    let addTime = order[CONSTANTS.JSON_KEYS.ADD_TIME]!
                    let userID = Int(order[CONSTANTS.JSON_KEYS.USER_ID]!)!
                    let orderID = Int(order[CONSTANTS.JSON_KEYS.ORDER_ID]!)!
                    let orderSN = order[CONSTANTS.JSON_KEYS.ORDER_SN]!
                    let totalPrice = Double(order[CONSTANTS.JSON_KEYS.TOTAL_PRICE]!)!
                    let status = order[CONSTANTS.JSON_KEYS.STATUS]!
                    
                    self.customerOrders.append(ProcessedOrder(addTime: addTime, userID: userID, totalPrice: totalPrice, sn: orderSN, id: orderID, status: status))
                }
            }
            completion()
            
        }

    }

}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return customerOrders.count
        case 1:
            return unprocessedOrders.count
        case 2:
            return processedOrders.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL, forIndexPath: indexPath) as! OrderTableViewCell
        
        if self.accountType == .Browser {
            cell.confirmButton.hidden = true
            cell.totalPriceLabel.hidden = true
        }
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            cell.confirmButton.hidden = true
        case 2:
            cell.statusLabel.hidden = true
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Perform segue to order list in future
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 117.0
    }
}
