//
//  SearchResultsTableViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/18/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import PopupController

class SearchResultsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delaysContentTouches = false
        for view in self.tableView.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)!.delaysContentTouches = false
                break
            }
        }
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
    
    func addProductToCart(button: UIButton) {
        let productPopup = AddProductPopupViewController.instance()
        let popup = PopupController.create(self).customize(
            [
                .Layout(.Center),
                .Animation(.SlideUp),
                .Scrollable(false),
                .BackgroundStyle(.BlackFilter(alpha: 0.7)),
                .MovesAlongWithKeyboard(true)
            ]
            ).didShowHandler { (popup) in
                print("showed popup")
            }
        productPopup.id_number = button.tag
        productPopup.closeHandler = { _ in
            popup.dismiss()
        }
        popup.show(productPopup)
    }
}
