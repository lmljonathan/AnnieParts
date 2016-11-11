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
    
    var searchIDs: [String: Int] = [:]
    var vehicleData: vehicle!
    private var loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.searchIDs)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 122
        self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "NoItemsCell", bundle: Bundle.main), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.NO_RESULTS_FOUND_CELL)
        self.tableView.register(UINib(nibName: "SearchResultsCell", bundle: Bundle.main), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.SEARCH_RESULTS_CELLS)

        configureTableView(sender: self.tableView)
        configureNavBarBackButton(sender: self.navigationController!, navItem: self.navigationItem)
        initializeActivityIndicator()
        loadData()
        initializeRefreshControl()
        
    }
    func initializeActivityIndicator() {
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.center = CGPoint(x: self.tableView.bounds.width/2, y: self.tableView.bounds.height/3)
        loadingIndicator.hidesWhenStopped = true
        self.view.addSubview(loadingIndicator)
    }
    func initializeRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "刷新")
        refreshControl.addTarget(self, action: #selector(SearchResultsTableViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    func loadData() {
        self.loadingIndicator.bringSubview(toFront: self.view)
        self.loadingIndicator.startAnimating()
        self.catalogData.removeAll()
        get_json_data(query_type: CONSTANTS.URL_INFO.OPTION_SEARCH, query_paramters: self.searchIDs as [String : AnyObject]) { (json) in
            
            if let productList = json![CONSTANTS.JSON_KEYS.SEARCH_RESULTS_LIST] as? [[String: AnyObject]]{
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
                    product.setMakeText(text: getMake(id: product.brandId))
                    product.setModelListText(text: getListOfModels(model_ids: product.modelIDlist))
                    self.catalogData.append(product)
                }
                if (self.catalogData.count == 0) {
                    self.noResultsFound = true
                } else {
                    self.noResultsFound = false
                }
                self.loadingIndicator.stopAnimating()
                self.title = String(self.catalogData.count) + "个产品"
                print(self.catalogData)
                self.tableView.reloadDataWithAutoSizingCells()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.noResultsFound) {
            return 1
        }
        return self.catalogData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.noResultsFound{
            return self.tableView.dequeueReusableCell(withIdentifier: CONSTANTS.CELL_IDENTIFIERS.NO_RESULTS_FOUND_CELL, for: indexPath as IndexPath)

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CONSTANTS.CELL_IDENTIFIERS.SEARCH_RESULTS_CELLS, for: indexPath as IndexPath) as! SearchResultsCell

            cell.selectionStyle = .none

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
            cell.loadImage(url: url)
            cell.addButton.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(button:)), for: .touchUpInside)
            cell.addButtonOver.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(button:)), for: .touchUpInside)
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.catalogData.count > 0{
            self.selectedProductIndex = indexPath.row
            let destVC = storyboard?.instantiateViewController(withIdentifier: "productDetail") as! ProductDetailViewController
            destVC.product = catalogData[indexPath.row]

            print(Int(self.catalogData[indexPath.row].productID)!)
            destVC.productID = Int(self.catalogData[indexPath.row].productID)!
            self.navigationController?.pushViewController(destVC, animated: true)
            self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.noResultsFound) {
            return 132
        } else {
            return UITableViewAutomaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath) as! SearchResultsCell
        cell.mainView.backgroundColor = UIColor.selectedGray()
        cell.backgroundColor = UIColor.clear
        cell.productImage.alpha = 0.8
    }

    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath) as! SearchResultsCell
        cell.mainView.backgroundColor = UIColor.white
        cell.productImage.alpha = 1
    }
    
    var selectedProductIndex: Int!
    func addProductToCart(button: UIButton) {
        let index = self.tableView.indexPathForRow(at: button.center)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self
        print(index?.row)
        let product = self.catalogData[(index?.row)!]
        vc.name = product.productName
        vc.id = String(product.productID)
        vc.sn = product.serialNumber
        vc.buttonString = CONSTANTS.ADD_TO_CART_LABEL
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request(query_type: CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: ["goods_id": id as AnyObject, CONSTANTS.JSON_KEYS.QUANTITY: quantity as AnyObject])
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        loadData()
        refreshControl.endRefreshing()
    }
    
}
