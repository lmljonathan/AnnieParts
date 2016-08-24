//
//  SearchOptionsVC.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/19/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import DropDown
struct Cell {
    var expanded: Bool
    var value: String
    var options: NSArray
    var option_ids: NSArray
    init() {
        expanded = false
        value = "SELECT ONE"
        options = []
        option_ids = []
    }
}
class SearchOptionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var oneView: UIView!
    @IBOutlet weak var twoView: UIView!
    @IBOutlet weak var threeView: UIView!
    @IBOutlet weak var searchButton: UIView!
    @IBOutlet var cartNavButton: UIBarButtonItem!
    
    @IBAction func performSearch(sender: AnyObject) {

        self.performSegueWithIdentifier(CONSTANTS.SEGUES.SHOW_SEARCH_RESULTS, sender: self)
    }
    // MARK: - Variables
    private var activeIndex = 0
    private var selectedOptions = [[""], ["", "", ""], [""]]
    private var selectedIDs = [[0], [0, 0, 0], [0]]
    private var sectionTitles: [[String]]! = [["BRAND"], ["YEAR", "MAKE", "MODEL"], ["PRODUCT"]]
    private var cells = [[Cell()], [Cell(), Cell(), Cell()], [Cell()]]

    // MARK: - View Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabs()
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        self.tableView.sectionHeaderHeight = 0
        self.tableView.sectionFooterHeight = 0
        self.tableView.tableFooterView = UIView()
        self.selectTab(activeIndex)
        self.navigationController?.addSideMenuButton()

        get_json_data(CONSTANTS.URL_INFO.CONFIG, query_paramters: [:]) { (json) in
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
                self.cells[0][0].options = brand.options
                self.cells[1][0].options = vehicle.year
                self.cells[1][1].options = vehicle.make
                self.cells[1][2].options = vehicle.allModel
                self.cells[2][0].options = product.products

                self.cells[0][0].option_ids = brand.optionsIDs
                self.cells[1][0].option_ids = vehicle.yearIDs
                self.cells[1][1].option_ids = vehicle.makeIDs
                self.cells[1][2].option_ids = vehicle.modelIDs
                self.cells[2][0].option_ids = product.productsIDs
                self.tableView.reloadData()
            }
        }
        self.navigationController?.navigationBarHidden = false
        self.searchButton.backgroundColor = UIColor.grayColor()
        self.searchButton.userInteractionEnabled = false
    }
    
    // MARK: - Table View Delegate Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cells[activeIndex].count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[activeIndex][section]
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cells[activeIndex][section].options.count > 0 && self.cells[activeIndex][section].expanded {
            print(self.cells[activeIndex][section].options.count + 1)
            return self.cells[activeIndex][section].options.count + 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("searchHeader") as! SearchOptionsHeaderCell
            if self.cells[activeIndex][indexPath.section].expanded {
                cell.expandedSymbol.text = "-"
            } else {
                cell.expandedSymbol.text = "+"
            }
            cell.selectedOption.text = self.cells[activeIndex][indexPath.section].value
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("optionCell") as! SearchOptionsCell
            cell.optionLabel.text = self.cells[activeIndex][indexPath.section].options[indexPath.row-1] as? String
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let expanded = self.cells[activeIndex][indexPath.section].expanded
        let options = self.cells[activeIndex][indexPath.section].options
        let option_ids = self.cells[activeIndex][indexPath.section].option_ids

        self.cells[activeIndex][indexPath.section].expanded = !expanded
        if expanded && indexPath.row > 0 {
            if options.count > 0 {
                self.cells[activeIndex][indexPath.section].value = (options[indexPath.row-1] as? String)!
                self.selectedOptions[activeIndex][indexPath.section] = (options[indexPath.row-1] as? String)!
                checkSelectedOptions()
            }
            if option_ids.count > 0 {
                self.selectedIDs[activeIndex][indexPath.section] = (option_ids[indexPath.row-1] as? Int)!
            }
        }
        self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 50.0
        }
        return 40.0
    }
    
    // MARK: - Main Functions
    func configureTabs() {
        self.oneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchByBrand)))
        self.twoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchByCar)))
        self.threeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchByProduct)))
    }
    func searchByBrand(){
        self.selectTab(0)
        self.tableView.reloadData()
    }
    func searchByCar(){
        self.selectTab(1)
        self.tableView.reloadData()
    }
    func searchByProduct(){
        self.selectTab(2)
        self.tableView.reloadData()
    }
    private func selectTab(index: Int){
        let tabViews = [oneView, twoView, threeView]
        for x in 0..<3{
            if x == index {
                tabViews[x].backgroundColor = UIColor.APred()
            } else {
                tabViews[x].backgroundColor = UIColor.APmediumGray()
            }
        }
        self.activeIndex = index
        self.checkSelectedOptions()
    }
    private func checkSelectedOptions(){
        switch activeIndex {
        case 0:
            if (!self.selectedOptions[activeIndex][0].isEmpty) {
                self.searchButton.enable(UIColor.APred())
            }else{
                self.searchButton.disable()
            }
        case 1:
            self.searchButton.disable()
            for option in self.selectedOptions[1] {
                if (!option.isEmpty) {
                    self.searchButton.enable(UIColor.APred())
                    break
                }
            }
            if (!self.selectedOptions[activeIndex][1].isEmpty) {
                configureModelList((self.selectedOptions[1])[1])
                self.cells[activeIndex][2].options = vehicle.model
                self.cells[activeIndex][2].option_ids = vehicle.modelIDs
            }
            else if (self.selectedOptions[activeIndex][0].isEmpty && self.selectedOptions[1][1].isEmpty) {
                self.cells[activeIndex][2].options = vehicle.allModel
                self.cells[activeIndex][2].option_ids = vehicle.allModelIDs
            }
        case 2:
            if (!self.selectedOptions[activeIndex][0].isEmpty) {
                self.searchButton.enable(UIColor.APred())
            }else{
                self.searchButton.disable()
            }
        default:
            break
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CONSTANTS.SEGUES.SHOW_SEARCH_RESULTS{
            let destVC = segue.destinationViewController as! SearchResultsTableViewController
            var result: [String: Int]! = [:]
            for (index, option) in self.selectedIDs[activeIndex].enumerate(){
                result[CONSTANTS.SEARCH_OPTIONS[activeIndex][index]] = option
            }
            destVC.searchIDs = result
        }
    }
}
