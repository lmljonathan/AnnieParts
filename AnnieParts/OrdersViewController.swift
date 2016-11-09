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
        if let vc = segue.sourceViewController as? ConfirmOrderViewController{
            let indexPath = NSIndexPath(forRow: vc.row, inSection: 0)
            self.confirmOrder(indexPath)
        }else if let vc = segue.sourceViewController as? OrderSummaryViewController{
            let indexPath = NSIndexPath(forRow: vc.row!, inSection: 0)
            self.confirmOrder(indexPath)
        }
    }
    
    @IBAction func unwindToOrdersWithCancel(segue: UIStoryboardSegue){
        let vc = segue.sourceViewController as! CancelOrderViewController
        let indexPath = vc.indexPath
    
        self.cancelOrder(indexPath)
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
            if (json!["status"] as! Int) == 1{
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
                        
                        self.unprocessedOrders.append(Order(addTime: addTime, userID: userID, totalPrice: totalPrice, sn: orderSN, id: orderID))
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
                        
                        self.processedOrders.append(ProcessedOrder(addTime: addTime, userID: userID, totalPrice: totalPrice, sn: orderSN, id: orderID, status: status))
                    }
                }
                completion()
            }
        }

    }
    
    private func confirmOrder(indexPath: NSIndexPath){
        let order = customerOrders[indexPath.row]
        get_json_data(CONSTANTS.URL_INFO.CONFIRM_BUSINESS_ORDER, query_paramters: ["order_id": String(order.id), "order_sn": order.sn]) { (json) in
            if (json!["status"] as! Int) == 1{
                print("Order #\(order.id) confirmed.")
                self.unprocessedOrders.append(self.customerOrders.removeAtIndex(indexPath.row))
                
                // Animate Cell
                let cell = self.ordersTableView.cellForRowAtIndexPath(indexPath)
                
                UIView.animateWithDuration(0.5, animations: {
                    cell?.transform = CGAffineTransformMakeTranslation(400, 0)
                    }, completion: {(success) in
                        self.ordersTableView.reloadData()
                        self.ordersTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Top)
                })
                
                self.showNotificationView("Order Confirmed!", image: UIImage(named: "checkmark")!, completion: { (vc) in
                    vc.dismissViewControllerAnimated(true, completion: nil)
                })
            }else{
                print("Failed at confirming order #\(order.id).")
            }
        }
    }
    
    private func cancelOrder(indexPath: NSIndexPath){
        
        func performCancel(orderID: Int){
            get_json_data(CONSTANTS.URL_INFO.CANCEL_ORDER, query_paramters: ["order_id": String(orderID)]) { (json) in
                if let success = json!["status"] as? Int{
                    if success == 1{
                        // Remove Item from Array
                        switch indexPath.section{
                        case 0:
                            self.customerOrders.removeAtIndex(indexPath.row)
                        case 1:
                            self.unprocessedOrders.removeAtIndex(indexPath.row)
                        default:
                            break
                        }
                        
                        // Animate Cell
                        let cell = self.ordersTableView.cellForRowAtIndexPath(indexPath)
                        
                        UIView.animateWithDuration(0.5, animations: {
                            cell?.transform = CGAffineTransformMakeTranslation(-400, 0)
                            }, completion: {(success) in
                                self.ordersTableView.reloadData()
                                //self.ordersTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Top)
                        })
                        
                        print("Canceled order #\(orderID) succesfully!")
                    }else{
                        print("Failed to cancel order #\(orderID).")
                    }
                }
            }
        }
        
        switch indexPath.section {
        case 0:
            let id = self.customerOrders[indexPath.row].id
            performCancel(id)
        case 1:
            let id = self.unprocessedOrders[indexPath.row].id
            performCancel(id)
        case 2:
            let id = self.processedOrders[indexPath.row].id
            performCancel(id)
        default:
            break
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
    
    func presentCancelOrder(button: UIButton){
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ORDER_CANCEL_MODAL) as! CancelOrderViewController
        customPresentViewController(orderSummaryPresentr(), viewController: vc, animated: true, completion: nil)
        // let row = button.tag
        let buttonPoint = button.convertPoint(CGPointZero, toView: self.ordersTableView)
        let indexPath = self.ordersTableView.indexPathForRowAtPoint(buttonPoint)
        vc.indexPath = indexPath
        self.ordersTableView.deselectRowAtIndexPath(indexPath!, animated: true)
    }

}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL, forIndexPath: indexPath as IndexPath) as! OrderTableViewCell
        
        cell.selectionStyle = .None
        cell.cancelButton.addTarget(self, action: #selector(self.presentCancelOrder(_:)), forControlEvents: .TouchUpInside)
        cell.cancelButton.tag = indexPath.row
        
        switch indexPath.section {
        case 0:
            cell.statusLabel.hidden = true
            cell.configureWith(customerOrders[indexPath.row])
            cell.cancelButton.hidden = false
            cell.confirmButton.hidden = false
            cell.confirmButton.addTarget(self, action: #selector(self.presentConfirmOrder(_:)), forControlEvents: .TouchUpInside)
            cell.confirmButton.tag = indexPath.row
        case 1:
            cell.confirmButton.hidden = true
            cell.cancelButton.hidden = false
            cell.statusLabel.hidden = true
            cell.configureWith(unprocessedOrders[indexPath.row])
        case 2:
            cell.statusLabel.hidden = false
            cell.confirmButton.hidden = true
            cell.cancelButton.hidden = true
            cell.configureWithProcessedOrder(processedOrders[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = self.ordersTableView.cellForRow(at: indexPath as IndexPath) as! OrderTableViewCell
        cell.mainView.backgroundColor = .selectedGray()
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = self.ordersTableView.cellForRow(at: indexPath as IndexPath) as! OrderTableViewCell
        cell.mainView.backgroundColor = .white
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CONSTANTS.VC_IDS.ORDER_SUMMARY_MODAL) as! OrderSummaryViewController
        vc.row = indexPath.row
        
        switch indexPath.section {
        case 0:
            vc.orderID = String(self.customerOrders[indexPath.row].id)
            vc.confirmActive = true
        case 1:
            vc.orderID = String(self.unprocessedOrders[indexPath.row].id)
            vc.confirmActive = false
        case 2:
            vc.orderID = String(self.processedOrders[indexPath.row].id)
            vc.confirmActive = false
        default:
            break
        }
        customPresentViewController(orderSummaryPresentr(), viewController: vc, animated: true, completion: nil)
        self.ordersTableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
}
