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
        let loading = startActivityIndicator(view: self.view)
        
        product_detail_request(product: self.product, product_id: product.product_id, completion: { (product) in
            self.tableView.reloadData()
            print("done with product detailed")
            if let detailCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProductDetailCell{
                detailCell.configureSlideshow(with: self.product.images)
            }
            self.tableView.separatorStyle = .singleLine
            loading.stopAnimating()
            
        })
    }

    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var number_of_available_sections = 1
        if (product.install_paths.count > 0) {
            number_of_available_sections += 1
        }
        if (product.video_paths.count > 0) {
            number_of_available_sections += 1
        }
        return number_of_available_sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        return 0
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
