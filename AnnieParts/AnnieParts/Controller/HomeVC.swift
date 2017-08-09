//
//  HomeVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/8/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        let loading = startActivityIndicator(view: self.view)
        new_products_request { (success, products) in
            loading.stopAnimating()
            self.products = products
            self.tableView.reloadDataInSection(section: 0)
        }
    }
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductCell")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showProductDetail") {
            if let destination = segue.destination as? ProductDetailsVC {
                destination.product = sender as? Product
            }
        }

    }
}
extension HomeVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            cell.initialize(data: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showProductDetail", sender: products[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
