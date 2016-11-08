//
//  SearchOptionsVC.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/19/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

struct Cell {
    var expanded: Bool
    var value: String
    var options: NSArray
    var option_ids: NSArray
    init() {
        expanded = false
        value = "选择"
        options = []
        option_ids = []
    }
    init(value: String) {
        expanded = false
        self.value = value
        options = []
        option_ids = []
    }
}
class SearchOptionsVC: UIViewController{
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var cartNavButton: UIBarButtonItem!
    
    @IBAction func performSearch(sender: AnyObject) {
        self.performSegue(withIdentifier: CONSTANTS.SEGUES.SHOW_SEARCH_RESULTS, sender: self)
    }
    // MARK: - Variables
    private var selectedOptions = ["", "", ""]
    private var selectedIDs = [0, 0, 0]
    private var sectionTitles: [String]! = ["车型", "品牌", "产品"]
    private var cells = [Cell(), Cell(), Cell()]

    // MARK: - View Loading Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.selectedIDs = [0, 0, 0]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        self.tableView.sectionHeaderHeight = 0
        self.tableView.sectionFooterHeight = 0
        self.tableView.tableFooterView = UIView()
        self.navigationController?.addSideMenuButton()

        get_json_data(query_type: CONSTANTS.URL_INFO.CONFIG, query_paramters: [:]) { (json) in
            if json!["status"] as! Int == 1 {
                brand.options.removeAll()
                vehicle.year.removeAll()
                vehicle.make.removeAll()
                vehicle.allModel.removeAll()
                product.products.removeAll()

                brand.optionsIDs.removeAll()
                vehicle.yearIDs.removeAll()
                vehicle.makeIDs.removeAll()
                vehicle.modelIDs.removeAll()
                product.productsIDs.removeAll()

                for dict in (json![CONSTANTS.JSON_KEYS.PRODUCT_MANUFACTURER] as! NSArray){
                    brand.optionsIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    brand.options.append(dict[CONSTANTS.JSON_KEYS.NAME] as! String)
                }
                for dict in (json![CONSTANTS.JSON_KEYS.PRODUCT_TYPES] as! NSArray){
                    product.productsIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    product.products.append(dict[CONSTANTS.JSON_KEYS.NAME] as! String)
                }
                for dict in (json![CONSTANTS.JSON_KEYS.YEAR_LIST] as! NSArray){
                    vehicle.yearIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    vehicle.year.append(String(dict[CONSTANTS.JSON_KEYS.NAME] as! Int))
                }
                
                for dict in (json![CONSTANTS.JSON_KEYS.MANUFACTURERS_LIST] as! NSArray){
                    vehicle.makeIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    vehicle.make.append(dict[CONSTANTS.JSON_KEYS.NAME] as! String)
                }
                
                for dict in (json![CONSTANTS.JSON_KEYS.MODEL_LIST] as! NSArray){
                    vehicle.allModelIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    vehicle.allModel.append(dict[CONSTANTS.JSON_KEYS.NAME] as! String)
                    vehicle.allModelPIDs.append(dict[CONSTANTS.JSON_KEYS.PARENT_ID] as! Int)
                }
                self.cells[0].options = vehicle.allModel
                self.cells[1].options = brand.options
                self.cells[2].options = product.products

                self.cells[0].option_ids = vehicle.allModelIDs
                self.cells[1].option_ids = brand.optionsIDs
                self.cells[2].option_ids = product.productsIDs
                self.tableView.reloadData()
            }
        }
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CONSTANTS.SEGUES.SHOW_SEARCH_RESULTS{
            let destVC = segue.destination as! SearchResultsTableViewController
            var result: [String: Int]! = [:]
            for (index, option) in self.selectedIDs.enumerated(){
                let key = CONSTANTS.SEARCH_OPTIONS[index]
                result[key] = option
            }
            destVC.searchIDs = result
        }
    }
}

extension SearchOptionsVC: UITabBarDelegate, UITableViewDataSource {
    // MARK: - Table View Delegate Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cells.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cells[section].options.count > 0 && self.cells[section].expanded {
            return self.cells[section].options.count + 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchHeader") as! SearchOptionsHeaderCell
            if self.cells[indexPath.section].expanded {
                cell.expandedSymbol.text = "-"
            } else {
                cell.expandedSymbol.text = "+"
            }
            cell.selectedOption.text = self.cells[indexPath.section].value
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "optionCell") as! SearchOptionsCell
            cell.optionLabel.text = self.cells[indexPath.section].options[indexPath.row-1] as? String
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let expanded = self.cells[indexPath.section].expanded
        let option_ids = self.cells[indexPath.section].option_ids
        self.cells[indexPath.section].expanded = !expanded
        
        if expanded && indexPath.row != 0 {
            if option_ids.count > 0 {
                self.selectedIDs[indexPath.section] = (option_ids[indexPath.row-1] as? Int)!
                self.performSegue(withIdentifier: CONSTANTS.SEGUES.SHOW_SEARCH_RESULTS, sender: self)
            }
        } else {
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, withRowAnimation: .Fade)
            self.tableView.scrollToRowAtIndexPath(indexPath as IndexPath, atScrollPosition: .Top, animated: true)
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 50.0
        }
        return 40.0
    }

}
