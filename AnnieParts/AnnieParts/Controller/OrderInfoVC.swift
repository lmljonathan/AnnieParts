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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configureTableView() {
        tableView.delegate = self
        let nib = UINib(nibName: "OrderInfoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OrderInfoCell")
    }

    @IBAction func closePopup(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension OrderInfoVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderinfo.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInfoVC", for: indexPath) as? OrderInfoCell {
            if (indexPath.row == orderinfo.count + 1) {
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
}
