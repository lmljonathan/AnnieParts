//
//  ProductListVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/13/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class ProductListVC: UITableViewController {

    var search_option_id: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        return cell
    }

}
