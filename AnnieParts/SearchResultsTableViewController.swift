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

    let cache = Shared.imageCache
    private var catalogData: [Product]! = []
    private var noResultsFound = false
    
    var searchIDs: [String: Int]!
    var vehicleData: vehicle!
    private var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,100,100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.searchIDs)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 122
        self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.registerNib(UINib(nibName: "NoItemsCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.NO_RESULTS_FOUND_CELL)
        self.tableView.registerNib(UINib(nibName: "SearchResultsCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.SEARCH_RESULTS_CELLS)

        configureTableView(self.tableView)
        configureNavBarBackButton(self.navigationController!, navItem: self.navigationItem)
        initializeActivityIndicator()
        loadData()
        initializeRefreshControl()
        
    }
    func initializeActivityIndicator() {
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.center = CGPoint(x: self.tableView.bounds.width/2, y: self.tableView.bounds.height/3)
        loadingIndicator.hidesWhenStopped = true
        self.view.addSubview(loadingIndicator)
    }
    func initializeRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "刷新")
        refreshControl.addTarget(self, action: #selector(SearchResultsTableViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    func loadData() {
        self.loadingIndicator.bringSubviewToFront(self.view)
        self.loadingIndicator.startAnimating()
        self.catalogData.removeAll()
        get_json_data(CONSTANTS.URL_INFO.OPTION_SEARCH, query_paramters: self.searchIDs) { (json) in
            
            if let productList = json![CONSTANTS.JSON_KEYS.SEARCH_RESULTS_LIST] as? NSArray {
                for product in productList {
                    let id = String(product[CONSTANTS.JSON_KEYS.ID] as? Int ?? -1)
                    let name = product[CONSTANTS.JSON_KEYS.NAME] as? String ?? ""
                    let img = product[CONSTANTS.JSON_KEYS.IMAGE] as? String ?? ""
                    let sn = product[CONSTANTS.JSON_KEYS.SERIAL_NUMBER] as? String ?? ""
                    let make = product[CONSTANTS.JSON_KEYS.MAKE_ID] as? Int ?? -1
                    let startYear = String(product[CONSTANTS.JSON_KEYS.START_YEAR] as? Int ?? -1)
                    let endYear = String(product[CONSTANTS.JSON_KEYS.END_YEAR] as? Int ?? -1)
                    
                    
                    // CHANGE THESE
                    var modelID = -1
                    if let x = product[CONSTANTS.JSON_KEYS.MODEL_ID] as? Int{
                        modelID = x
                    }
                    var modelIDlist: [Int] = []
                    if let x = product[CONSTANTS.JSON_KEYS.MODEL_ID_LIST] as? [Int]{
                        modelIDlist = x
                    }
                    let product = Product(productID: id, productName: name, image: img, serialNumber: sn, startYear: startYear, endYear: endYear, brandID: make, price: 0, modelID: modelID, modelIDlist: modelIDlist)
                    product.setMakeText(getMake(product.brandId))
                    product.setModelListText(getListOfModels(product.modelIDlist))
                    self.catalogData.append(product)
                }
                if (self.catalogData.count == 0) {
                    self.noResultsFound = true
                } else {
                    self.noResultsFound = false
                }
                self.loadingIndicator.stopAnimating()
                self.title = String(self.catalogData.count) + "个产品"
                self.tableView.reloadDataWithAutoSizingCells()
                //self.tableView.reloadSectionWithAutoSizingCells(0, animation: .Automatic)
                //self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)

            }
        }
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
            cell.productName.text = product.productName
            
            if product.startYear != "0" && product.endYear != "0"{
                cell.year.text = product.startYear + " - " + product.endYear
            }else{
                cell.year.text = "No Years Specified"
            }
            cell.manufacturer.text = product.makeText
            cell.models.text = product.modelListText
            cell.serialNumber.text = product.serialNumber
            let url = NSURL(string: product.imagePath)!
            cell.loadImage(url)
            cell.addButton.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(_:)), forControlEvents: .TouchUpInside)
            cell.addButtonOver.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(_:)), forControlEvents: .TouchUpInside)
//            
//            cell.mainViewHeightContraint.constant = 110 + 16 * CGFloat(cell.models.numberOfLines)
//            cell.needsUpdateConstraints()
//            
            return cell
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.catalogData.count > 0{
            self.selectedProductIndex = indexPath.row
            let destVC = storyboard?.instantiateViewControllerWithIdentifier("productDetail") as! ProductDetailViewController
            destVC.product = catalogData[indexPath.row]

            print(Int(self.catalogData[indexPath.row].productID)!)
            destVC.productID = Int(self.catalogData[indexPath.row].productID)!
            self.navigationController?.pushViewController(destVC, animated: true)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.noResultsFound) {
            return 132
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath) as! SearchResultsCell
        cell.mainView.backgroundColor = UIColor.APlightGray()
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath) as! SearchResultsCell
        cell.mainView.backgroundColor = UIColor.whiteColor()
    }
    
    var selectedProductIndex: Int!
    func addProductToCart(button: UIButton) {
        let buttonPosition = button.convertPoint(CGPointZero, toView: self.tableView)
        let index = self.tableView.indexPathForRowAtPoint(buttonPosition)
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self
        
        let product = self.catalogData[(index?.row)!]
        vc.name = product.productName
        vc.id = String(product.productID)
        vc.sn = product.serialNumber
        vc.buttonString = CONSTANTS.ADD_TO_CART_LABEL
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request(CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: ["goods_id": id, CONSTANTS.JSON_KEYS.QUANTITY: quantity])
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        loadData()
        refreshControl.endRefreshing()
    }
    
}
