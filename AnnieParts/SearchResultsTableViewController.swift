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
    private var noResultsFound = false
    
    var searchIDs: [String: Int]!
    var vehicleData: vehicle!
    private var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,100,100))
    
    override func viewDidLoad() {
        self.tableView.registerNib(UINib(nibName: "NoItemsCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.NO_RESULTS_FOUND_CELL)
        self.tableView.separatorStyle = .None
        self.navigationController?.addSideMenuButton()
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(image: UIImage(named: CONSTANTS.IMAGES.BACK_BUTTON), style: .Done, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
        
        createSearchParameters()
        initializeActivityIndicator()
        loadData()
        initializeRefreshControl()
        super.viewDidLoad()
    }
    func initializeActivityIndicator() {
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.center = CGPoint(x: self.tableView.bounds.width/2, y: self.tableView.bounds.height/3)
        loadingIndicator.hidesWhenStopped = true
        self.view.addSubview(loadingIndicator)
    }
    func initializeRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(SearchResultsTableViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    func createSearchParameters() {
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
    }
    func loadData() {
        self.tableView.separatorStyle = .None
        self.loadingIndicator.bringSubviewToFront(self.view)
        self.loadingIndicator.startAnimating()
        self.catalogData.removeAll()
        get_json_data(CONSTANTS.URL_INFO.OPTION_SEARCH, query_paramters: self.searchParameters) { (json) in
            if let productList = json![CONSTANTS.JSON_KEYS.SEARCH_RESULTS_LIST] as? NSArray {
                for product in productList {
                    let id = String(product[CONSTANTS.JSON_KEYS.ID] as! Int)
                    let name = product[CONSTANTS.JSON_KEYS.NAME] as! String
                    let img = product[CONSTANTS.JSON_KEYS.IMAGE] as! String
                    let sn = product[CONSTANTS.JSON_KEYS.SERIAL_NUMBER] as! String
                    let make = String(product[CONSTANTS.JSON_KEYS.MAKE_ID] as! Int)
                    let startYear = String(product[CONSTANTS.JSON_KEYS.START_YEAR] as! Int)
                    let endYear = String(product[CONSTANTS.JSON_KEYS.END_YEAR] as! Int)
                    self.catalogData.append(Product(productID: id, productName: name, image: img, serialNumber: sn, startYear: startYear, endYear: endYear, brandID: make, price: 0))
                }
                if (self.catalogData.count == 0) {
                    self.noResultsFound = true
                } else {
                    self.noResultsFound = false
                }
                
                let seconds = 3.0
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    
                    self.loadingIndicator.stopAnimating()
                    self.tableView.separatorStyle = .SingleLine
                    self.tableView.reloadData()
                    
                })
                
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
        if (self.noResultsFound) {
            return 1
        }
        return self.catalogData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.noResultsFound{
            return self.tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.NO_RESULTS_FOUND_CELL, forIndexPath: indexPath)

        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.SEARCH_RESULTS_CELLS, forIndexPath: indexPath) as! SearchResultsCell
            
            let product = self.catalogData[indexPath.row]
            cell.addButton.tag = indexPath.row
            cell.productName.text = product.productName
            cell.year.text = product.startYear + " - " + product.endYear
            cell.manufacturer.text = getMake(product.brandId)
            cell.serialNumber.text = product.serialNumber
            let url = NSURL(string: CONSTANTS.URL_INFO.BASE_URL + product.imagePath)!
            cell.loadImage(url)
            cell.addButton.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(_:)), forControlEvents: .TouchUpInside)
            cell.addButtonOver.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(_:)), forControlEvents: .TouchUpInside)
            
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.catalogData.count > 0{
            self.performSegueWithIdentifier(CONSTANTS.SEGUES.SHOW_PRODUCT_DETAIL, sender: self)
        }
    }
    
    func addProductToCart(button: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self
        
        let product = self.catalogData[button.tag]
        vc.name = product.productName
        vc.id = String(product.productID)
        vc.buttonString = CONSTANTS.ADD_TO_CART_LABEL
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request(CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: ["goods_id": id, CONSTANTS.JSON_KEYS.QUANTITY: quantity])
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        loadData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
