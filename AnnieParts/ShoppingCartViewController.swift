//
//  ShoppingCartViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/20/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Presentr

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddProductModalView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var checkoutButton: UIButton!
    @IBOutlet weak var subtotal: UILabel!
    private var shoppingCart: [ShoppingCart]! = []
    private var updatedItem: Int!
    var viewFromNavButton = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.updatedItem = -1
    }
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100

        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        if (User.userRank == 1) {
            self.subtotal.hidden = true
        }
        if (self.viewFromNavButton) {
            configureNavBarBackButton(self.navigationController!, navItem: self.navigationItem)
            viewFromNavButton = false
        } else {
            removeNavBarBackButton(self.navigationController!, navItem: self.navigationItem)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureTableView(self.tableView)

        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(SearchResultsTableViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)

        loadData()
        super.viewDidLoad()
    }
    func calculateSubtotal() {
        print("hello")
        var subtotal = 0.0
        for product in self.shoppingCart {
            subtotal += product.price * Double(product.quantity)
        }
        let priceFormatter = NSNumberFormatter()
        priceFormatter.numberStyle = .CurrencyStyle
        self.subtotal.text = "Subtotal: " + priceFormatter.stringFromNumber(subtotal)!
    }
    func loadData() {
        print("load Data")
        self.shoppingCart.removeAll()
        get_json_data(CONSTANTS.URL_INFO.SHOPPING_CART, query_paramters: [:]) { (json) in
            if let products = json![CONSTANTS.JSON_KEYS.SEARCH_RESULTS_LIST] as? NSArray {
                print("array")
                for product in products {
                    let id = product[CONSTANTS.JSON_KEYS.ID] as! String
                    let name = product[CONSTANTS.JSON_KEYS.NAME] as! String
                    let img = product[CONSTANTS.JSON_KEYS.IMAGE] as! String
                    let make = product[CONSTANTS.JSON_KEYS.MAKE_ID] as! Int
                    let sn = product[CONSTANTS.JSON_KEYS.SERIAL_NUMBER] as! String
                    let startYear = String(product[CONSTANTS.JSON_KEYS.START_YEAR] as! Int)
                    let endYear = String(product[CONSTANTS.JSON_KEYS.END_YEAR] as! Int)
                    let quantity = Int(product[CONSTANTS.JSON_KEYS.PRODUCT_QUANTITY] as! String)
                    let price = Double(product[CONSTANTS.JSON_KEYS.PRICE] as! String)
                    
                    let modelID = product[CONSTANTS.JSON_KEYS.MODEL_ID] as! Int
                    let modelIDlist = product[CONSTANTS.JSON_KEYS.MODEL_ID_LIST] as! [Int]

                    let shoppingItem = ShoppingCart(productID: id, productName: name, image: img, serialNumber: sn, startYear: startYear, endYear: endYear, brandID: make, price: price!, quantity: quantity!, modelID: modelID, modelIDlist: modelIDlist)
                    shoppingItem.setMakeText(getMake(shoppingItem.brandId))
                    shoppingItem.setModelListText(getListOfModels(shoppingItem.modelIDlist))
                    self.shoppingCart.append(shoppingItem)
                }
                self.tableView.reloadData()
            }
            print("calculate")
            self.calculateSubtotal()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingCart.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.SHOPPING_CART_CELLS) as! ShoppingCartCell
        cell.configureCell()
        let product = self.shoppingCart[indexPath.row]
        cell.productName.text = product.productName
        let url = NSURL(string: product.imagePath)!
        cell.loadImage(url)
        
        cell.quantityLabel.text = String(product.quantity)
        cell.serialNumber.text = product.serialNumber
        if (User.userRank == 1) {
            cell.priceLabel.hidden = true
        }
        cell.priceLabel.text = "$" + String(format: "%.2f", product.price)
        cell.manufacturer.text = product.makeText
        cell.modelListLabel.text = product.modelListText
        
        cell.quantitySelectButton.addTarget(self, action: #selector(self.editItemQuantity(_:)), forControlEvents: .TouchUpInside)
        cell.quantitySelectButton.addTarget(self, action: #selector(self.highlightView(_:)), forControlEvents: .TouchDown)
        cell.quantitySelectButton.addTarget(self, action: #selector(self.normalizeView(_:)), forControlEvents: .TouchDragExit)
        cell.deleteButton.addTarget(self, action: #selector(self.deleteItemFromCart(_:)), forControlEvents: .TouchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.highlightView(_:)), forControlEvents: .TouchDown)
        cell.deleteButton.addTarget(self, action: #selector(self.normalizeView(_:)), forControlEvents: .TouchDragExit)
        return cell
    }
    
    func highlightView(view: UIView){
        UIView.animateWithDuration(0.5) {
            view.alpha = 0.6
        }
    }
    
    func normalizeView(view: UIView){
        UIView.animateWithDuration(0.5) {
            view.alpha = 1
        }
    }
    
    
    
    @IBAction func editItemQuantity(sender: UIButton) {
        self.normalizeView(sender)
        let index = self.tableView.indexPathForRowAtPoint(sender.convertPoint(CGPointZero, toView: self.tableView))
        self.updatedItem = index!.row
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self
        
        let item = self.shoppingCart[index!.row]
        vc.id = item.productID
        vc.name = item.productName
        vc.sn = item.serialNumber
        vc.quantity = item.quantity
        vc.buttonString = CONSTANTS.UPDATE_CART_LABEL
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    @IBAction func deleteItemFromCart(sender:UIButton) {
        let index = self.tableView.indexPathForRowAtPoint(sender.convertPoint(CGPointZero, toView: self.tableView))
        send_request(CONSTANTS.URL_INFO.DELETE_FROM_CART, query_paramters: ["goods_id": self.shoppingCart[index!.row].productID])
        self.shoppingCart.removeAtIndex(index!.row)
        
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([index!], withRowAnimation: .Fade)
        self.tableView.endUpdates()
        
    }
    @IBAction func checkout(sender: UIButton) {
        sender.enabled = false
        get_json_data(CONSTANTS.URL_INFO.CHECKOUT, query_paramters: [:]) { (json) in
            // store the order id
            sender.enabled = true
        }
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        if (self.updatedItem != -1) {
            self.shoppingCart[self.updatedItem].editQuantity(quantity)
            self.tableView.reloadData()
            self.updatedItem = -1
        }
        
        send_request(CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: [CONSTANTS.JSON_KEYS.ID: id, CONSTANTS.JSON_KEYS.QUANTITY: quantity, CONSTANTS.JSON_KEYS.ACTION: "set"])
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadData()
        calculateSubtotal()
        refreshControl.beginRefreshing()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}
