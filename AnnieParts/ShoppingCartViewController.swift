//
//  ShoppingCartViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/20/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Presentr

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddProductModalView, OrderSummaryModalView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var checkoutButton: UIButton!
    @IBOutlet weak var subtotal: UILabel!
    private var shoppingCart: [ShoppingCart]! = []
    private var updatedItem: Int!
    var viewFromNavButton = true
    
    @IBAction func unwindToCartWithConfirm(segue: UIStoryboardSegue){
        self.shoppingCart.removeAll()
        self.tableView.reloadData()
        self.subtotal.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.updatedItem = -1
    }
    
    override func viewDidLoad() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100

        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        if (User.userRank == 1) {
            self.subtotal.isHidden = true
        }
        if (self.viewFromNavButton) {
            configureNavBarBackButton(sender: self.navigationController!, navItem: self.navigationItem)
            viewFromNavButton = false
        } else {
            removeNavBarBackButton(sender: self.navigationController!, navItem: self.navigationItem)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureTableView(sender: self.tableView)

        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "刷新")
        refreshControl.addTarget(self, action: #selector(SearchResultsTableViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)

        loadData()
        super.viewDidLoad()
    }

    func calculateSubtotal() {
        var subtotal = 0.0
        for product in self.shoppingCart {
            subtotal += product.price * Double(product.quantity)
        }
        if (subtotal > 0) {
            let priceFormatter = NumberFormatter()
            priceFormatter.numberStyle = .currency
            self.subtotal.text = "Subtotal: " + priceFormatter.string(from: subtotal as NSNumber)!
        }
    }
    func loadData() {
        self.shoppingCart.removeAll()
        get_json_data(query_type: CONSTANTS.URL_INFO.SHOPPING_CART, query_paramters: [:]) { (json) in
            if let products = json![CONSTANTS.JSON_KEYS.SEARCH_RESULTS_LIST] as? [AnyObject] {
                for product: AnyObject in products {
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
                    shoppingItem.setMakeText(text: getMake(id: shoppingItem.brandId))
                    shoppingItem.setModelListText(text: getListOfModels(model_ids: shoppingItem.modelIDlist))
                    self.shoppingCart.append(shoppingItem)
                }
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            self.calculateSubtotal()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CONSTANTS.CELL_IDENTIFIERS.SHOPPING_CART_CELLS) as! ShoppingCartCell
        cell.configureCell()
        let product = self.shoppingCart[indexPath.row]
        cell.productName.text = product.productName
        let url = NSURL(string: product.imagePath)!
        cell.loadImage(url: url)
        
        cell.quantityLabel.text = String(product.quantity)
        cell.serialNumber.text = product.serialNumber
        if (User.userRank == 1) {
            cell.priceLabel.isHidden = true
        }
        cell.priceLabel.text = "$" + String(format: "%.2f", product.price)
        cell.manufacturer.text = product.makeText
        cell.modelListLabel.text = product.modelListText

        cell.quantitySelectButton.addTarget(self, action: #selector(self.editItemQuantity(_:)), for: .touchUpInside)
        cell.quantitySelectButton.addTarget(self, action: #selector(self.highlightView(view:)), for: .touchDown)
        cell.quantitySelectButton.addTarget(self, action: #selector(self.normalizeView(view: )), for: .touchDragExit)

        cell.deleteButton.addTarget(self, action: #selector(self.deleteItemFromCart(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.highlightView(view:)), for: .touchDown)
        cell.deleteButton.addTarget(self, action: #selector(self.normalizeView(view: )), for: .touchDragExit)
        return cell
    }
    
    func highlightView(view: UIView){
        UIView.animate(withDuration: 0.5) {
            view.alpha = 0.6
        }
    }
    
    func normalizeView(view: UIView){
        UIView.animate(withDuration: 0.5) {
            view.alpha = 1
        }
    }
    
    
    
    @IBAction func editItemQuantity(_ sender: UIButton) {
        self.normalizeView(view: sender)
        let index = self.tableView.indexPathForRow(at: sender.convert(.zero, to: self.tableView))
        self.updatedItem = index!.row
        print(self.updatedItem)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self
        
        let item = self.shoppingCart[index!.row]
        vc.id = item.productID
        vc.name = item.productName
        vc.sn = item.serialNumber
        vc.quantity = item.quantity
        vc.buttonString = CONSTANTS.UPDATE_CART_LABEL
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    
    @IBAction func deleteItemFromCart(_ sender:UIButton) {
        let index = self.tableView.indexPathForRow(at: sender.convert(.zero, to: self.tableView))
        send_request(query_type: CONSTANTS.URL_INFO.DELETE_FROM_CART, query_paramters: ["goods_id": self.shoppingCart[index!.row].productID as AnyObject])
        self.shoppingCart.remove(at: index!.row)
        
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [index!], with: .fade)
        self.tableView.endUpdates()
        
    }
    @IBAction func checkout(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CONSTANTS.VC_IDS.ORDER_SUMMARY_MODAL) as! OrderSummaryViewController
        vc.shoppingCart = self.shoppingCart
        vc.delegate = self
        customPresentViewController(orderSummaryPresentr(), viewController: vc, animated: true, completion: nil)
        
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        if (self.updatedItem != -1) {
            self.shoppingCart[self.updatedItem].editQuantity(num: quantity)
            self.tableView.reloadData()
            self.updatedItem = -1
        }
        print("\(self.updatedItem) + \(id) + \(quantity)")
        send_request(query_type: CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: [CONSTANTS.JSON_KEYS.GOODS_ID: id as AnyObject, CONSTANTS.JSON_KEYS.QUANTITY: quantity as AnyObject, CONSTANTS.JSON_KEYS.ACTION: "set" as AnyObject])
    }
    func confirmedShoppingCart(clear: Bool) {
        if (clear) {
            self.shoppingCart.removeAll()
            self.tableView.reloadData()
            self.subtotal.text = ""
            get_json_data(query_type: CONSTANTS.URL_INFO.CHECKOUT, query_paramters: [:], completion: { (json) in
                let sn = json![CONSTANTS.JSON_KEYS.SERIAL_NUMBER] as? String
                let vc = self.storyboard?.instantiateViewController(withIdentifier: CONSTANTS.VC_IDS.ORDER_NUMBER) as! OrderNumberVC
                vc.sn_label = sn
                self.dismiss(animated: true, completion: {
                    self.customPresentViewController(orderNumberPresentr(), viewController: vc, animated: true, completion: {
                        self.shoppingCart.removeAll()
                        self.tableView.reloadData()
                    })
                })

            })
        }
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        loadData()
        calculateSubtotal()
        refreshControl.beginRefreshing()
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        refreshControl.endRefreshing()
    }
}
