//
//  OrderInfoVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/1/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class OrderInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var orderinfo: [OrderItem] = []
    var total: Double = 0
    var order_number: String = "Order #"
    var order_id: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        let loading = startActivityIndicator(view: self.view)
        order_info_request(order_id: order_id) { (success, orderinfo) in
            loading.stopAnimating()
            self.orderinfo = orderinfo
            self.tableView.reloadData()
        }
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "OrderInfoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OrderInfoCell")
    }

    @IBAction func closePopup(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension OrderInfoVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (orderinfo.count == 0) {
            return 0
        }
        return orderinfo.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInfoCell", for: indexPath) as? OrderInfoCell {
            if (indexPath.row == orderinfo.count) {
                cell.initalize(orderitem: OrderItem(name: "Total:", quantity: 0, price: total))
            }
            else {
                cell.initalize(orderitem: orderinfo[indexPath.row])
                total += orderinfo[indexPath.row].price * Double(orderinfo[indexPath.row].quantity)
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        title.text = order_number
        title.textAlignment = .center
        title.textColor = UIColor.darkGray
        title.font = UIFont.systemFont(ofSize: 18)
        return title
    }
}
