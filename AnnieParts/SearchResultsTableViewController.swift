//
//  SearchResultsTableViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/18/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Presentr
import Haneke

class SearchResultsTableViewController: UITableViewController, AddProductModalView {

    var searchParameters = [String: Int]()
    let cache = Shared.imageCache
    private var catalogData: [Product]!
    
    var searchIDs: [String: Int]!
    var vehicleData: vehicle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.addSideMenuButton()
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(image: UIImage(named: CONSTANTS.IMAGES.BACK_BUTTON), style: .Done, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
        
        if (self.catalogData == nil) {
            self.catalogData = []
        }
        if let year = self.searchIDs["YEAR"] {
            self.searchParameters[CONSTANTS.JSON_KEYS.YEAR] = year
        }
        if let brand = self.searchIDs["MAKE"] {
            self.searchParameters[CONSTANTS.JSON_KEYS.MAKE] = brand
        }
        if let model = self.searchIDs["MODEL"] {
            self.searchParameters[CONSTANTS.JSON_KEYS.MODEL] = model
        }
        if let attr = self.searchIDs["PRODUCT TYPE"] {
            self.searchParameters[CONSTANTS.JSON_KEYS.PRODUCT_TYPE] = attr
        }
        if let pinpai = self.searchIDs["BRAND"] {
            self.searchParameters[CONSTANTS.JSON_KEYS.PRODUCT_MANUFACTURER] = pinpai
        }
        
        self.showLoadingView("Getting Products") { (loadingVC) in
            
            MySingleton.sharedInstance.configureTableViewScroll(self.tableView)
            
            self.loadData({
                loadingVC.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
    }
    
    func loadData(completion:() -> Void) {
        get_json_data(CONSTANTS.URL_INFO.OPTION_SEARCH, query_paramters: self.searchParameters) { (json) in
            if let productList = json![CONSTANTS.JSON_KEYS.SEARCH_RESULTS_LIST] as? NSArray {
                for product in productList {
                    let id = String(product[CONSTANTS.JSON_KEYS.ID] as! Int)
                    let name = product[CONSTANTS.JSON_KEYS.NAME] as! String
                    let img = product[CONSTANTS.JSON_KEYS.IMAGE] as! String
                    let make = String(product[CONSTANTS.JSON_KEYS.MAKE_ID] as! Int)
                    let startYear = String(product[CONSTANTS.JSON_KEYS.START_YEAR] as! Int)
                    let endYear = String(product[CONSTANTS.JSON_KEYS.END_YEAR] as! Int)
                    self.catalogData.append(Product(productID: id, productName: name, image: img, startYear: startYear, endYear: endYear, brandID: make))
                }
                self.tableView.reloadData()
                completion()
            }
        }
    }
    
    private func getMake(id: String) -> String{
        let id: Int! = Int(id)!
        let index = vehicleData.makeIDs.indexOf(id)
        
        return vehicleData.make[index!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.catalogData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.SEARCH_RESULTS_CELLS, forIndexPath: indexPath) as! SearchResultsCell
        let product = self.catalogData[indexPath.row]
        cell.addButton.tag = indexPath.row
        cell.productName.text = product.productName
        cell.year.text = product.startYear + " - " + product.endYear
        cell.manufacturer.text = getMake(product.brandId)
    
        let url = NSURL(string: CONSTANTS.URL_INFO.BASE_URL + product.imagePath)!
        cell.loadImage(url)
        cell.addButton.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(_:)), forControlEvents: .TouchUpInside)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(CONSTANTS.SEGUES.SHOW_PRODUCT_DETAIL, sender: self)
    }
    
    func addProductToCart(button: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self
        
        //TODO: - SEND ID OF PRODUCT TO VIEW CONTROLLER
        let product = self.catalogData[button.tag]
        vc.name = product.productName
        vc.id = String(product.productID)
        vc.buttonString = CONSTANTS.ADD_TO_CART_LABEL
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request(CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: [CONSTANTS.JSON_KEYS.PRODUCT_ID: id, CONSTANTS.JSON_KEYS.QUANTITY: quantity])
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.beginRefreshing()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
