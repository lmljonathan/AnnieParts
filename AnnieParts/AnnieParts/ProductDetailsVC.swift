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
    private var details = Details()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()

        details.addOption(new_option: Details.Option())
        if (product.install_titles.count > 0) {
            details.addOption(new_option: Details.Option(option_array: product.install_titles, option_paths_array: product.install_paths, title: "Install"))
        }
        if (product.video_paths.count > 0) {
            details.addOption(new_option: Details.Option(option_array: product.video_paths, option_paths_array: product.video_paths, title: "Videos"))
        }
        configureTableView()
    }
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        print(details.detail_options.count)
        tableView.reloadData()
    }
    func registerNibs()
    {
        let productDetail = UINib(nibName: "ProductDetailCell", bundle: nil)
        tableView.register(productDetail, forCellReuseIdentifier: "ProductDetailCell")

        let productDescription = UINib(nibName: "ProductDescriptionCell", bundle: nil)
        tableView.register(productDescription, forCellReuseIdentifier: "ProductDescriptionCell")

        let searchHeader = UINib(nibName: "SearchHeaderCell", bundle: nil)
        tableView.register(searchHeader, forCellReuseIdentifier: "SearchHeaderCell")

        let labelCell = UINib(nibName: "LabelCell", bundle: nil)
        tableView.register(labelCell, forCellReuseIdentifier: "LabelCell")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return details.detail_options.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if (product.description.isEmpty) {
                return 1
            }
            return 2
        }
        else {
            if (!details.detail_options[section].expanded) {
                return 1
            }
            return details.detail_options[section].options.count + 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailCell", for: indexPath) as! ProductDetailCell
                cell.slideshowScrollView.delegate = self
                cell.initialize(data: product, parent: self)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDescriptionCell", for: indexPath) as! ProductDescriptionCell
                cell.initializeProductDescription(product: product)
                return cell
            }
        }
        else {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHeaderCell", for: indexPath) as! SearchHeaderCell
                cell.initialize(expanded: details.detail_options[indexPath.section].expanded)
                cell.title.text = details.detail_options[indexPath.section].category
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LabelCell
                cell.initialize(title: details.detail_options[indexPath.section].options[indexPath.row-1])
                return cell
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section > 0) {
            let expanded = details.detail_options[indexPath.section].expanded

            if (expanded && indexPath.row > 0) {
                performSegue(withIdentifier: "showWebView", sender: nil)
            }
            else {
                details.detail_options[indexPath.section].expanded = !expanded
                tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            tableView.deselectRow(at: indexPath, animated: false)
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
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0.01
        }
        else {
            return 5
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showWebView") {
            let destination = segue.destination as! WebViewVC
            let index = tableView.indexPathForSelectedRow
            destination.path = details.detail_options[index!.section].option_paths[index!.row-1]
        }
    }
}
