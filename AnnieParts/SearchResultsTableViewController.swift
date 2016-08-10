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

    override func viewDidLoad() {
        self.navigationController?.addSideMenuButton()
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(SearchResultsTableViewController.unwind)), atIndex:0)
        
        self.tableView.delaysContentTouches = false
        for view in self.tableView.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)!.delaysContentTouches = false
                break
            }
        }
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 5
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultsCell", forIndexPath: indexPath) as! SearchResultsCell
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(SearchResultsTableViewController.addProductToCart(_:)), forControlEvents: .TouchUpInside)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    func addProductToCart(button: UIButton) {
        let width = ModalSize.Default
        let height = ModalSize.Custom(size: 200)
        let center = ModalCenterPosition.TopCenter
        let presenter = Presentr(presentationType: .Custom(width: width, height: height, center: center))
        presenter.blurBackground = true
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("popup") as! AddProductModalViewController
        vc.delegate = self
        
        //TODO: - SEND ID OF PRODUCT TO VIEW CONTROLLER
        vc.id = "slkdfjklds"
        vc.buttonString = "Add to Cart"
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        print(id)
        print(quantity)
        // send product id to shopping cart (http request)
    }
    
    func unwind() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
