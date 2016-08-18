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
    private var shoppingCart: [ShoppingCart]!
    private var updatedItem: Int!
    var viewFromNavButton = true;
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.updatedItem = -1
    }
    override func viewDidLoad() {
        self.navigationController?.addSideMenuButton()
        if (self.viewFromNavButton) {
            self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(image: UIImage(named: CONSTANTS.IMAGES.BACK_BUTTON), style: .Done, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
            viewFromNavButton = false
        } else {
            
            if self.navigationItem.leftBarButtonItems?.count == 3 {
                self.navigationItem.leftBarButtonItems?.removeAtIndex(0)
            }
        }
        if self.shoppingCart == nil {
            self.shoppingCart = []
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        MySingleton.sharedInstance.configureTableViewScroll(self.tableView)
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(SearchResultsTableViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        loadData()
        calculateSubtotal()
        if self.tableView.numberOfRowsInSection(0) == 0{
            self.checkoutButton.disable()
        }
        
        super.viewDidLoad()
    }
    func calculateSubtotal() {
        var subtotal = 0.0
        for product in self.shoppingCart {
            subtotal += product.price
        }
        let priceFormatter = NSNumberFormatter()
        priceFormatter.numberStyle = .CurrencyStyle
        self.subtotal.text = "Subtotal: " + priceFormatter.stringFromNumber(subtotal)!
    }
    func loadData() {
        self.shoppingCart.removeAll()
        get_json_data(CONSTANTS.URL_INFO.SHOPPING_CART, query_paramters: [:]) { (json) in
            print(json)
            if let products = json![CONSTANTS.JSON_KEYS.SEARCH_RESULTS_LIST] as? NSArray {
                for product in products {
                    let id = product[CONSTANTS.JSON_KEYS.ID] as! String
                    let name = product[CONSTANTS.JSON_KEYS.NAME] as! String
                    let img = product[CONSTANTS.JSON_KEYS.IMAGE] as! String
                    let make = String(product[CONSTANTS.JSON_KEYS.MAKE_ID] as! Int)
                    let sn = product[CONSTANTS.JSON_KEYS.SERIAL_NUMBER] as! String
                    let startYear = String(product[CONSTANTS.JSON_KEYS.START_YEAR] as! Int)
                    let endYear = String(product[CONSTANTS.JSON_KEYS.END_YEAR] as! Int)
                    let quantity = Int(product[CONSTANTS.JSON_KEYS.PRODUCT_QUANTITY] as! String)
                    let price = Double(product[CONSTANTS.JSON_KEYS.PRICE] as! String)
                    self.shoppingCart.append(ShoppingCart(productID: id, productName: name, image: img, serialNumber: sn, startYear: startYear, endYear: endYear, brandID: make, price: price!, quantity: quantity!))
                }
                self.tableView.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.shoppingCart.count)
        return self.shoppingCart.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.SHOPPING_CART_CELLS) as! ShoppingCartCell
        cell.configureCell()
        let product = self.shoppingCart[indexPath.row]
        cell.productName.text = product.productName
        let url = NSURL(string: CONSTANTS.URL_INFO.BASE_URL + product.imagePath)!
        cell.loadImage(url)
        cell.quantityLabel.text = String(product.quantity)
        cell.serialNumber.text = product.serialNumber
        cell.quantitySelectButton.addTarget(self, action: #selector(self.editItemQuantity(_:)), forControlEvents: .TouchUpInside)
        cell.quantitySelectButton.addTarget(self, action: #selector(self.highlightView(_:)), forControlEvents: .TouchDown)
        cell.quantitySelectButton.addTarget(self, action: #selector(self.normalizeView(_:)), forControlEvents: .TouchCancel)
        
        cell.changeQuantityButton.addTarget(self, action: #selector(self.editItemQuantity(_:)), forControlEvents: .TouchUpInside)
        
        cell.deleteButton.addTarget(self, action: #selector(self.deleteItemFromCart(_:)), forControlEvents: .TouchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.highlightView(_:)), forControlEvents: .TouchDown)
        cell.deleteButton.addTarget(self, action: #selector(self.normalizeView(_:)), forControlEvents: .TouchCancel)
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
        let index = self.tableView.indexPathForRowAtPoint(sender.convertPoint(CGPointZero, toView: self.tableView))
        self.updatedItem = index!.row
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self
        
        let item = self.shoppingCart[index!.row]
        vc.id = item.productID
        vc.name = item.productName
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
