//
//  ProductDetailsVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/26/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class ProductDetailsVC: UITableViewController {

    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        tableView.separatorStyle = .none
    }
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return " Install"
        case 2:
            return " Videos"
        default:
            return ""
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productDetailCell", for: indexPath) as! ProductDetailCell
            
            cell.slideshowScrollView.delegate = self
            cell.initialize(data: product, parent: self)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pathCell", for: indexPath) as! LabelCell
            if (indexPath.section == 1) {
                cell.initialize(title: product.install_titles[indexPath.row])
            } else {
                cell.initialize(title: product.video_paths[indexPath.row])
            }
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return tableView.frame.height
        }
        else {
            return 50
        }
    }
}
