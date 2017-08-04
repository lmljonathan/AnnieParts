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
    var ordernumber: String = "Order #"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        let oi1 = OrderItem(name: "brakelsdkjflasdlkflkasdf1", quantity: 2, price: 20.0)
        let oi2 = OrderItem(name: "brake2", quantity: 4, price: 10.0)
        let oi3 = OrderItem(name: "brakefds3", quantity: 600, price: 90.0)
        orderinfo = [oi1, oi2, oi3]
        tableView.reloadData()
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
        print(orderinfo.count)
        return orderinfo.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInfoCell", for: indexPath) as? OrderInfoCell {
            if (indexPath.row == orderinfo.count) {
                cell.initalize(orderitem: OrderItem(name: "Total:", quantity: 0, price: total))
            }
            else {
                cell.initalize(orderitem: orderinfo[indexPath.row])
                total += orderinfo[indexPath.row].price
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
        title.text = ordernumber
        title.textAlignment = .center
        title.textColor = UIColor.darkGray
        title.font = UIFont.systemFont(ofSize: 16)
        return title
    }
}
