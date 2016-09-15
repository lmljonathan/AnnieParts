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
        case Customer, Unprocessed, Processed
    }
    
    enum UserRank {
        case Browser, Dealer
    }

    @IBOutlet var ordersTableView: UITableView!
    
    @IBAction func unwindToOrdersWithConfirmation(segue: UIStoryboardSegue){
        let vc = segue.sourceViewController as! ConfirmOrderViewController
        let indexPath = NSIndexPath(forRow: vc.row, inSection: 0)

        self.confirmOrder(indexPath)
    }
    
    var accountType: UserRank!
    var sectionTitles: [String]!
    
    var customerOrders: [Order] = []
    var unprocessedOrders: [Order] = []
    var processedOrders: [ProcessedOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User.userRank = 2 // Uncomment to test as dealer
        
        self.navigationItem.title = "Orders"
        
//        // Test Data
//        let order = Order(addTime: "December 32", userID: 32312, totalPrice: 34.00, sn: "1412312", id: 3413124213)
//        let processedOrder = ProcessedOrder(addTime: order.addTime, userID: order.userID, totalPrice: order.totalPrice, sn: order.sn, id: order.id, status: "On its way")
//        customerOrders.append(order)
//        unprocessedOrders.append(order)
//        processedOrders.append(processedOrder)

        self.ordersTableView.registerNib(UINib(nibName: "OrderCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL)
        
        self.setUserRank()
        self.loadData {
            self.ordersTableView.reloadData()
        }
        
    }
    
    private func setUserRank() {
        if User.userRank == 1{
            accountType = .Browser
            self.sectionTitles = ["Unprocessed Orders", "Processed Orders"]
        }else{
            accountType = .Dealer
            self.sectionTitles = ["Customer Orders", "Unprocessed Orders", "Processed Orders"]
        }
    }
    
    private func loadData(completion: () -> Void){
        get_json_data(CONSTANTS.URL_INFO.ORDER_LIST, query_paramters: [:]) { (json) in
            
            if self.accountType != .Browser{
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
    
    private func confirmOrder(indexPath: NSIndexPath){
        let order = customerOrders[indexPath.row]
        get_json_data(CONSTANTS.URL_INFO.CONFIRM_BUSINESS_ORDER, query_paramters: ["order_id": String(order.id), "order_sn": order.sn]) { (json) in
            if (json!["status"] as! Int) == 1{
                print("Order #\(order.id) confirmed.")
                self.unprocessedOrders.append(self.customerOrders.removeAtIndex(indexPath.row))
                self.ordersTableView.reloadData()
            }else{
                print("Failed at confirming order #\(order.id).")
            }
        }
        
    }
    
    func presentConfirmOrder(button: UIButton){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ORDER_CONFIRM_MODAL) as! ConfirmOrderViewController
        customPresentViewController(orderSummaryPresentr(), viewController: vc, animated: true, completion: nil)
        let row = button.tag
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        vc.row = row
        self.ordersTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.accountType == .Dealer{
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
        }else{
            switch section {
            case 0:
                return unprocessedOrders.count
            case 1:
                return processedOrders.count
            default:
                return 0
            }

        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL, forIndexPath: indexPath) as! OrderTableViewCell
        
        cell.selectionStyle = .None
        
        if self.accountType == .Dealer{
            // If user is Dealer
            switch indexPath.section {
            case 0:
                cell.statusLabel.hidden = true
                cell.configureWith(customerOrders[indexPath.row])
                
                cell.confirmButton.addTarget(self, action: #selector(self.presentConfirmOrder(_:)), forControlEvents: .TouchUpInside)
                cell.confirmButton.tag = indexPath.row
            case 1:
                cell.confirmButton.hidden = true
                cell.statusLabel.hidden = true
                cell.configureWith(unprocessedOrders[indexPath.row])
            case 2:
                cell.confirmButton.hidden = true
                cell.configureWithProcessedOrder(processedOrders[indexPath.row])
            default:
                break
            }
        }else{
            // If user is Browser
            cell.totalPriceLabel.hidden = true
            cell.confirmButton.hidden = true
            
            switch indexPath.section {
            case 0:
                cell.statusLabel.hidden = true
                cell.configureWith(unprocessedOrders[indexPath.row])
            case 1:
                cell.statusLabel.hidden = false
                cell.configureWithProcessedOrder(processedOrders[indexPath.row])
            default:
                break
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.ordersTableView.cellForRowAtIndexPath(indexPath) as! OrderTableViewCell
        cell.mainView.backgroundColor = UIColor.selectedGray()
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.ordersTableView.cellForRowAtIndexPath(indexPath) as! OrderTableViewCell
        cell.mainView.backgroundColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ORDER_SUMMARY_MODAL) as! OrderSummaryViewController
        
        if self.accountType == .Dealer{
            switch indexPath.section {
            case 0:
                vc.orderID = String(self.customerOrders[indexPath.row].id)
                vc.confirmActive = true // CHANGE
            case 1:
                vc.orderID = String(self.unprocessedOrders[indexPath.row].id)
                vc.confirmActive = false
            case 2:
                vc.orderID = String(self.processedOrders[indexPath.row].id)
                vc.confirmActive = false
            default:
                break
            }
        }else{
            switch indexPath.section {
            case 0:
                vc.orderID = String(self.unprocessedOrders[indexPath.row].id)
                vc.confirmActive = false
            case 1:
                vc.orderID = String(self.processedOrders[indexPath.row].id)
                vc.confirmActive = false
            default:
                break
            }
        }
        
        customPresentViewController(orderSummaryPresentr(), viewController: vc, animated: true, completion: nil)
        self.ordersTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
}
