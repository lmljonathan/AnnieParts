//
//  SearchResultsTableViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/18/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Presentr

class SearchResultsTableViewController: UITableViewController, AddProductModalView {

    var searchParameters: [String:Int]!
    private var catalogData: [Product]!
    
    override func viewDidLoad() {
        if (self.catalogData == nil) {
            self.catalogData = []
        }
        self.searchParameters = ["brand": 0, "model": 0, "attr": 3, "year": 0, "pinpai": 0]
        self.navigationController?.addSideMenuButton()
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(title: "Back", style: .Plain, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
        MySingleton.sharedInstance.configureTableViewScroll(self.tableView)
        
        loadData()
        
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func loadData() {
        get_json_data("catalog", query_paramters: self.searchParameters) { (json) in
            if let productList = json!["rlist"] as? NSArray {
                print(productList)
                for product in productList {
                    let id = String(product["id"] as! Int)
                    let name = product["name"] as! String
                    let img = product["img"] as! String
                    self.catalogData.append(Product(productID: id, productName: name, image: img))
                }
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.catalogData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultsCell", forIndexPath: indexPath) as! SearchResultsCell
        cell.addButton.tag = indexPath.row
        cell.productName.text = self.catalogData[indexPath.row].productName
        cell.addButton.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(_:)), forControlEvents: .TouchUpInside)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    func addProductToCart(button: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("popup") as! AddProductModalViewController
        vc.delegate = self
        
        //TODO: - SEND ID OF PRODUCT TO VIEW CONTROLLER
        vc.id = String(self.catalogData[button.tag].productID)
        vc.buttonString = "Add to Cart"
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request("addToCart", query_paramters: ["id": id, "cnt": quantity])
    }
}
