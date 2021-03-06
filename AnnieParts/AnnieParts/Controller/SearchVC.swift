//
//  SearchVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/12/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let SEARCH_OPTIONS_TITLES = ["车型", "品牌", "产品"]
    var selected_search_option_id: Int = -1
    var selected_category: String = ""
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

        let loading = startActivityIndicator(view: self.view)
        configureIDS { (success) in
            if (success) {
                search_options_request(completion: { (search_result) in
                    CONSTANTS.search = search_result
                    self.tableView.reloadData()
                    loading.stopAnimating()
                })
            }
        }
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showProductList") {
            let destinationVC = segue.destination as? ProductListVC
            destinationVC?.search_query = selected_category + "=" + String(selected_search_option_id)
        }
    }
    // MARK: - Table view data source
}

extension SearchVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return CONSTANTS.search.search_options.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let search_option = CONSTANTS.search.search_options[section]
        if (search_option.options.count > 0 && search_option.expanded) {
            return search_option.options.count + 1
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchHeaderCell") as! SearchHeaderCell
            cell.initialize(expanded: CONSTANTS.search.search_options[indexPath.section].expanded)
            return cell
        }
        else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "labelCell") as! LabelCell
            cell.initialize(title: CONSTANTS.search.search_options[indexPath.section].options[indexPath.row-1])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SEARCH_OPTIONS_TITLES[section]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let search_option = CONSTANTS.search.search_options[indexPath.section]
        let option_ids = search_option.option_ids
        let expanded = search_option.expanded
        CONSTANTS.search.search_options[indexPath.section].expanded = !expanded

        if (expanded && indexPath.row > 0) {
            if (option_ids.count > 0) {
                selected_search_option_id = option_ids[indexPath.row - 1]
                selected_category = search_option.category
                self.performSegue(withIdentifier: "showProductList", sender: nil)
                self.tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        else {
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "System", size: 20.0)
        header.textLabel?.textAlignment = .center
    }
}
