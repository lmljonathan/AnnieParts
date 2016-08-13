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
        self.performSegueWithIdentifier("showResults", sender: self)
    }
    
    // MARK: - Variables
    private var dropDown = DropDown()
    private var data = [["BRAND"], ["YEAR", "MAKE", "MODEL"], ["PRODUCT TYPE"]]
    private var brandData = brand()
    private var vehicleData = vehicle()
    private var productData = product()
    private var activeIndex = 0
    private var searchIDs: [String: Int]!
    private var selectedOptions = [[""], ["", "", ""], [""]]
    
    // MARK: - View Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // cartNavButton.addBadge() // CHANGE - Need to fix badge in UIExtensions
        self.selectTab(0)
        self.activeIndex = 0
        self.navigationController?.addSideMenuButton()
        let options = [oneView: "searchByBrand:", twoView: "searchByCar:", threeView: "searchByProduct:"]
        for view in options.keys{
            self.addTapGR(view, action: Selector(options[view]!))
        }
        get_json_data("config", query_paramters: [:]) { (json) in
            if json!["status"] as! Int == 1 {
                for dict in (json!["pinpai"] as! NSArray){
                    self.brandData.optionsIDs.append(dict["id"] as! Int)
                    self.brandData.options.append(dict["name"] as! String)
                }
                for dict in (json!["attributes"] as! NSArray){
                    self.productData.productsIDs.append(dict["id"] as! Int)
                    self.productData.products.append(dict["name"] as! String)
                }
                for dict in (json!["years"] as! NSArray){
                    self.vehicleData.yearIDs.append(dict["id"] as! Int)
                    self.vehicleData.year.append(String(dict["name"] as! Int))
                }
                
                for dict in (json!["manufactures"] as! NSArray){
                    self.vehicleData.makeIDs.append(dict["id"] as! Int)
                    self.vehicleData.make.append(dict["name"] as! String)
                }
                
                for dict in (json!["models"] as! NSArray){
                    self.vehicleData.allModelIDs.append(dict["id"] as! Int)
                    self.vehicleData.allModel.append(dict["name"] as! String)
                    self.vehicleData.allModelPIDs.append(dict["pid"] as! Int)
                }
                self.tableView.reloadData()
            }
        }
        self.searchButton.layer.cornerRadius = 5
        self.navigationController?.navigationBarHidden = false
        self.searchButton.backgroundColor = UIColor.grayColor()
        self.searchButton.userInteractionEnabled = false
    }
    
    // MARK: - Table View Delegate Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data[activeIndex].count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectCell", forIndexPath: indexPath) as! SelectorTableViewCell
        cell.delegate = self
        cell.configureCell(data[activeIndex][indexPath.section])
        
        // Disables the Model Option 
        if indexPath == NSIndexPath(forRow: 0, inSection: 2) && vehicleData.model.count == 0{
            cell.disable()
            cell.selectLabel.text = "SELECT A MAKE"
        }else if indexPath == NSIndexPath(forRow: 0, inSection: 2) && vehicleData.model.count > 0{
            cell.selectLabel.text = "SELECT ONE"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SelectorTableViewCell
        var dataSource = []
        switch activeIndex {
        case 0:
            dataSource = brandData.options
        case 1:
            switch indexPath.section {
            case 0:
                dataSource = vehicleData.year
            case 1:
                dataSource = vehicleData.make
            case 2:
                dataSource = vehicleData.model
            default:
                break
            }
        case 2:
            dataSource = productData.products
        default:
            break
        }
        cell.showDropDown(dataSource as! [String])
    }
    
    // MARK: - Main Functions
    func searchByBrand(gr: UITapGestureRecognizer){
        self.selectTab(0)
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SelectorTableViewCell
        if (selectedOptions[0])[0] != ""{
            cell.selectLabel.text = (selectedOptions[0])[0]
        }else{
            cell.selectLabel.text = "SELECT ONE"
        }
        self.tableView.reloadData()
    }
    
    func searchByCar(gr: UITapGestureRecognizer){
        self.selectTab(1)
        self.tableView.reloadData()
        for section in [0, 1, 2]{
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as! SelectorTableViewCell
            if (selectedOptions[1])[section] != ""{
                cell.selectLabel.text = (selectedOptions[1])[section]
            }else{
                cell.selectLabel.text = "SELECT ONE"
            }
        }
        self.tableView.reloadData()
    }
    
    func searchByProduct(gr: UITapGestureRecognizer){
        self.selectTab(2)
        self.tableView.reloadData()
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! SelectorTableViewCell
        if (selectedOptions[2])[0] != ""{
            cell.selectLabel.text = (selectedOptions[2])[0]
        }else{
            cell.selectLabel.text = "SELECT ONE"
        }
        self.tableView.reloadData()
    }
    
    func setupDropDown(view: UIView){
        // The view to which the drop down will appear on
        dropDown.anchorView = view // UIView or UIBarButtonItem
        dropDown.direction = .Bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:view.bounds.height)
        dropDown.cellHeight = 44
        dropDown.backgroundColor = UIColor.lightGrayColor()
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
    }
    
    private func selectTab(index: Int){
        let tabViews = [oneView, twoView, threeView]
        for x in 0..<3{
            if x != index{
                (tabViews[x]).backgroundColor = UIColor.darkGrayColor()
            }else{
                (tabViews[x]).backgroundColor = UIColor.lightGrayColor()
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
                modelCell.selectLabel.text = "SELECT ONE"
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
    
    @IBAction func queryProducts(sender: UIButton) {
        self.performSegueWithIdentifier("showResults", sender: self)
    }
    
    private func checkSelectedOptions(){
        switch activeIndex {
        case 0:
            if self.selectedOptions[0] != [""]{
                self.searchButton.enable(UIColor.redColor())
            }else{
                self.searchButton.disable()
            }
        case 1:
            if (self.selectedOptions[1])[0] != "" && (self.selectedOptions[1])[1] != "" && (self.selectedOptions[1])[2] != ""{
                self.searchButton.enable(UIColor.redColor())
            }else{
                self.searchButton.disable()
            }
        case 2:
            if self.selectedOptions[2] != [""]{
                self.searchButton.enable(UIColor.redColor())
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
        
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showResults"{
            let destVC = segue.destinationViewController as! SearchResultsTableViewController
            destVC.searchIDs = self.searchIDs
        }
    }
}
