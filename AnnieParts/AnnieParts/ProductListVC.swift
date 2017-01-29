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

        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none

        let loading = startActivityIndicator(view: self.view)
        product_list_request(search_query: search_query, completion: { (products) in
            self.products = products
            self.tableView.reloadData()
            self.tableView.separatorStyle = .singleLine
            loading.stopAnimating()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == CONSTANTS.SEGUES.DETAIL) {
            let destinationVC = segue.destination as? ProductDetailsVC
            let index = tableView.indexPathForSelectedRow
            destinationVC?.product = products[(index?.row)!]
            tableView.deselectRow(at: index!, animated: false)
        }
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CONSTANTS.SEGUES.DETAIL, sender: nil)
        //self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
