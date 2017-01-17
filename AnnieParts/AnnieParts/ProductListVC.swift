//
//  ProductListVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/13/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class ProductListVC: UITableViewController {

    var search_query: String = ""
    private var products: [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        let loading = startActivityIndicator(view: self.view)
        product_list_request(search_query: search_query, completion: { (products) in
            self.products = products
            self.tableView.reloadData()
            loading.stopAnimating()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == CONSTANTS.SEGUES.DETAIL) {
            let destinationVC = segue.destination as? ProductDetailVC
            destinationVC?.product = products[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }

    func configureTableView() {
        self.tableView.tableHeaderView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.initialize(data: products[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: CONSTANTS.SEGUES.DETAIL, sender: nil)
    }
}
