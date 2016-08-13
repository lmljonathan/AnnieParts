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

    var searchParameters: [String:Int]!
    let cache = Shared.imageCache
    private var catalogData: [Product]!
    
    var searchIDs: [String: Int]!
    
    override func viewDidLoad() {
        if (self.catalogData == nil) {
            self.catalogData = []
        }
        self.searchParameters = ["brand": 0, "model": 0, "attr": 3, "year": 0, "pinpai": 0]
        self.navigationController?.addSideMenuButton()
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(image: UIImage(named: "cart"), style: .Done, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
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
                for product in productList {
                    let id = String(product["id"] as! Int)
                    let name = product["name"] as! String
                    let img = product["img"] as! String
                    let startYear = String(product["start_time"] as! Int)
                    let endYear = String(product["end_time"] as! Int)
                    self.catalogData.append(Product(productID: id, productName: name, image: img, startYear: startYear, endYear: endYear))
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
        let product = self.catalogData[indexPath.row]
        cell.addButton.tag = indexPath.row
        cell.productName.text = product.productName
        cell.year.text = product.startYear + " - " + product.endYear
    
        let url = NSURL(string: "http://www.annieparts.com/" + product.imagePath)!
        cell.loadImage(url)
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
        let product = self.catalogData[button.tag]
        vc.name = product.productName
        vc.id = String(product.productID)
        vc.buttonString = "Add to Cart"
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request("addToCart", query_paramters: ["id": id, "cnt": quantity])
    }
}
