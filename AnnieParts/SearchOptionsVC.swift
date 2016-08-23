//
//  SearchOptionsVC.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/19/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import DropDown

protocol PassBackOptionDelegate {
    func selectOption(sender: SelectorTableViewCell, option: String)
}

class SearchOptionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, PassBackOptionDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var oneView: UIView!
    @IBOutlet weak var twoView: UIView!
    @IBOutlet weak var threeView: UIView!
    @IBOutlet weak var searchButton: UIView!
    @IBOutlet var cartNavButton: UIBarButtonItem!
    
    @IBAction func performSearch(sender: AnyObject) {
        func getIDs() -> [String: Int]{
            let dataDict = [[brandData.options], [vehicleData.year, vehicleData.make, vehicleData.model], [productData.products]]
            let idDict = [[brandData.optionsIDs], [vehicleData.yearIDs, vehicleData.makeIDs, vehicleData.modelIDs], [productData.productsIDs]]

            var result: [String: Int]! = [:]
            for (index, option) in self.selectedOptions[activeIndex].enumerate(){
                let optionIndex = ((dataDict[activeIndex])[index]).indexOfObject(option)
                result[(data[activeIndex])[index]] = ((idDict[activeIndex])[index])[optionIndex]
            }
            return result
        }
        self.searchIDs = getIDs()
        self.performSegueWithIdentifier(CONSTANTS.SEGUES.SHOW_SEARCH_RESULTS, sender: self)
    }
    
    // MARK: - Variables
    private var data = CONSTANTS.SEARCH_OPTIONS
    private var brandData = brand()
    private var vehicleData = vehicle()
    private var productData = product()
    private var activeIndex = 0
    private var searchIDs: [String: Int]!
    private var selectedOptions = [[""], ["", "", ""], [""]]
    
    private var expandedRows: Int = 1
    private var cells = [
        [
            ["expanded": false, "value": "Brand", "options": []]
        ],
        [
            ["expanded": false, "value": "Year", "options": []],
            ["expanded": false, "value": "Make", "options": []],
            ["expanded": false, "value": "Model", "options": []],
        ],
        [
            ["expanded": false, "value": "Product", "options": []]
        ],
    ]
    
    // MARK: - View Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
        self.tableView.sectionHeaderHeight = 10.0
        self.tableView.sectionFooterHeight = 10.0
        
        self.selectTab(0)
        self.activeIndex = 0
        self.navigationController?.addSideMenuButton()
        let options = [oneView: CONSTANTS.SEARCH_OPTION_VIEWS[0], twoView: CONSTANTS.SEARCH_OPTION_VIEWS[1], threeView: CONSTANTS.SEARCH_OPTION_VIEWS[2]]
        for view in options.keys{
            self.addTapGR(view, action: Selector(options[view]!))
        }
        get_json_data(CONSTANTS.URL_INFO.CONFIG, query_paramters: [:]) { (json) in
            if json!["status"] as! Int == 1 {
                for dict in (json![CONSTANTS.JSON_KEYS.PRODUCT_MANUFACTURER] as! NSArray){
                    self.brandData.optionsIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    self.brandData.options.append(dict[CONSTANTS.JSON_KEYS.NAME] as! String)
                }
                for dict in (json![CONSTANTS.JSON_KEYS.PRODUCT_TYPES] as! NSArray){
                    self.productData.productsIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    self.productData.products.append(dict[CONSTANTS.JSON_KEYS.NAME] as! String)
                }
                for dict in (json![CONSTANTS.JSON_KEYS.YEAR_LIST] as! NSArray){
                    self.vehicleData.yearIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    self.vehicleData.year.append(String(dict[CONSTANTS.JSON_KEYS.NAME] as! Int))
                }
                
                for dict in (json![CONSTANTS.JSON_KEYS.MANUFACTURERS_LIST] as! NSArray){
                    self.vehicleData.makeIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    self.vehicleData.make.append(dict[CONSTANTS.JSON_KEYS.NAME] as! String)
                }
                
                for dict in (json![CONSTANTS.JSON_KEYS.MODEL_LIST] as! NSArray){
                    self.vehicleData.allModelIDs.append(dict[CONSTANTS.JSON_KEYS.ID] as! Int)
                    self.vehicleData.allModel.append(dict[CONSTANTS.JSON_KEYS.NAME] as! String)
                    self.vehicleData.allModelPIDs.append(dict[CONSTANTS.JSON_KEYS.PARENT_ID] as! Int)
                }
                self.cells[0][0]["options"] = self.brandData.options
                self.cells[1][0]["options"] = self.vehicleData.year
                self.cells[1][1]["options"] = self.vehicleData.make
                self.cells[1][2]["options"] = self.vehicleData.model
                self.cells[2][0]["options"] = self.productData.products
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let expand_array = self.cells[activeIndex][section]["options"] as? NSArray {
            if let expanded = self.cells[activeIndex][section]["expanded"] as? Bool {
                if expand_array.count > 0 && expanded {
                    return expand_array.count + 1
                }
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("searchHeader") as! SearchOptionsHeaderCell
            cell.selectedOption.text = self.cells[activeIndex][indexPath.section]["value"] as? String
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("optionCell") as! SearchOptionsCell
            cell.optionLabel.text = (self.cells[activeIndex][indexPath.section]["options"] as! NSArray)[indexPath.row-1] as? String
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let expanded = self.cells[activeIndex][indexPath.section]["expanded"] as? Bool {
            print(expanded)
            if expanded && indexPath.row > 0 {
                if let options = self.cells[activeIndex][indexPath.section]["options"] as? NSArray {
                    if options.count > 0 {
                         self.cells[activeIndex][indexPath.section]["value"] = options[indexPath.row-1] as! String
                    }
                }
            }
            self.cells[activeIndex][indexPath.section]["expanded"] = !expanded
        }
        self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
    }
    
    // MARK: - Main Functions
    func searchByBrand(gr: UITapGestureRecognizer){
        self.selectTab(0)
        self.tableView.reloadData()
    }
    
    func searchByCar(gr: UITapGestureRecognizer){
        self.selectTab(1)
        self.tableView.reloadData()
    }
    
    func searchByProduct(gr: UITapGestureRecognizer){
        self.selectTab(2)
        self.tableView.reloadData()
    }
    
    
    private func selectTab(index: Int){
        let tabViews = [oneView, twoView, threeView]
        for x in 0..<3{
            if x != index{
                (tabViews[x]).backgroundColor = UIColor.APmediumGray()
            }else{
                (tabViews[x]).backgroundColor = UIColor.APred()
            }
        }
        self.activeIndex = index
        self.checkSelectedOptions()
        print("selected tab index", index)
    }
    
    private func addTapGR(view: UIView, action: Selector){
        let gr = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gr)
    }
    
    // MARK: - Get data selected by selector
    func selectOption(sender: SelectorTableViewCell, option: String) {
        switch sender.titleLabel.text! {
        case "BRAND":
            (self.selectedOptions[0])[0] = option
        case "YEAR":
            (self.selectedOptions[1])[0] = option
        case "MAKE":
            if (self.selectedOptions[1])[1] != option{
                (self.selectedOptions[1])[1] = option
                let modelCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as! SelectorTableViewCell
                self.configureModels(option)
                modelCell.selectLabel.text = "Select One"
                modelCell.enable()
                
                // Clears model
                (self.selectedOptions[1])[2] = ""
            }
        case "MODEL":
            (self.selectedOptions[1])[2] = option
        case "PRODUCT TYPE":
            (self.selectedOptions[2])[0] = option
        default:
            break
        }
        checkSelectedOptions()
    }
    private func checkSelectedOptions(){
        switch activeIndex {
        case 0:
            if self.selectedOptions[0] != [""]{
                self.searchButton.enable(UIColor.APred())
            }else{
                self.searchButton.disable()
            }
        case 1:
            if (self.selectedOptions[1])[0] != "" && (self.selectedOptions[1])[1] != "" && (self.selectedOptions[1])[2] != ""{
                self.searchButton.enable(UIColor.APred())
            }else{
                self.searchButton.disable()
            }
        case 2:
            if self.selectedOptions[2] != [""]{
                self.searchButton.enable(UIColor.APred())
            }else{
                self.searchButton.disable()
            }
        default:
            break
        }
    }
    
    private func configureModels(selectedMake: String){
        func getID() -> Int{
            let optionIndex = vehicleData.make.indexOf(selectedMake)
            return vehicleData.makeIDs[optionIndex!]
        }
        
        func getIDOfModel(model: String) -> Int{
            let index = vehicleData.allModel.indexOf(model)
            return vehicleData.allModelIDs[index!]
        }
        
        // Get ID of selected make
        let pid = getID()
        
        // Clears vehicleData of current models
        vehicleData.model.removeAll()
        vehicleData.modelIDs.removeAll()
        vehicleData.modelPIDs.removeAll()
        
        // Add new data
        var resultIndexes: [Int]! = []
        for (index, id) in vehicleData.allModelPIDs.enumerate(){
            if id == pid{
                resultIndexes.append(index)
                vehicleData.modelPIDs.append(id)
            }
        }
        for index in resultIndexes{
            vehicleData.model.append(self.vehicleData.allModel[index])
        }
        for model in vehicleData.model{
            vehicleData.modelIDs.append(getIDOfModel(model))
        }
        self.cells[activeIndex][3]["options"] = self.vehicleData.model
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CONSTANTS.SEGUES.SHOW_SEARCH_RESULTS{
            let destVC = segue.destinationViewController as! SearchResultsTableViewController
            destVC.searchIDs = self.searchIDs
            destVC.vehicleData = self.vehicleData
        }
    }
}
