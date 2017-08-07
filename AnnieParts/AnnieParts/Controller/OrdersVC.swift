//
//  OrdersVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/20/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import Presentr
import SwipeCellKit

class OrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var orders: [[Order]]!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        let o1 = Order(order_id: 100, user_id: 100, serial_number: "slkfjdsdfj", total: 39, status: "shipping")
        let o2 = Order(order_id: 100, user_id: 100, serial_number: "slkfjdsdfj", total: 39, status: "shipping")
        let o3 = Order(order_id: 100, user_id: 100, serial_number: "slkfjdsdfj", total: 39, status: "shipping")
        self.orders = [[o1, o2], [o3], []]
        tableView.reloadData()
//        order_list_request { (success, orders) in
//            if (success) {
//                self.orders = orders
//                self.tableView.reloadData()
//            }
//            else {
//                performLogin(vc: self)
//            }
//        }
    }
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "OrderCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OrderCell")
    }

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(orders[segmentedControl.selectedSegmentIndex].count)
        return orders[segmentedControl.selectedSegmentIndex].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell {
            cell.initialize(order: orders[segmentedControl.selectedSegmentIndex][indexPath.row])
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presenter = Presentr(presentationType: .fullScreen)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderInfoVC") as? OrderInfoVC {
            customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        let order = self.orders[segmentedControl.selectedSegmentIndex][indexPath.row]

        if (segmentedControl.selectedSegmentIndex == 0) {
            if (orientation == .right) {
                let confirmAction = SwipeAction(style: .default, title: "Confirm") { action, indexPath in
                    self.confirmOrder(order: order)
                }
                confirmAction.backgroundColor = UIColor(colorLiteralRed: 0, green: 204.0/255.0, blue: 0, alpha: 1)
                confirmAction.image = UIImage(named: "check")
                return [confirmAction]
            }
            else {
                let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                    self.cancelOrder(order: order)
                }
                deleteAction.image = UIImage(named: "trash")
                return [deleteAction]
            }
        }
        else if (segmentedControl.selectedSegmentIndex == 1) {
            if (orientation == .left) {
                let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                    self.cancelOrder(order: order)
                }
                return [deleteAction]
            }
        }
        return []
    }

    func confirmOrder(order: Order) {
        confirm_order_request(order_id: order.order_id) { (success) in
            
        }
    }

    func cancelOrder(order: Order) {
        cancel_order_request(order_id: order.order_id) { (success) in

        }
    }
}
