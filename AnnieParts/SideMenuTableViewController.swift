//
//  SideMenuTableViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/24/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userStatus: UILabel!
    
    private let segues = ["showCenterSearch", "showCenterShoppingCart", "showCenterLogin"]
    private let vcNames = ["Search", "Shopping Cart", "Logout"]
    private var previousIndex: NSIndexPath?
    override func viewDidLoad() {
        self.tableView.tableHeaderView = self.userInfoView
        self.userStatus.text = User.getUserStatus()
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
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return segues.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell")!
        cell.textLabel?.text = self.vcNames[indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let index = previousIndex {
            tableView.deselectRowAtIndexPath(index, animated: true)
        }
        if indexPath.row == 2 {
            logout()
            self.sideMenuController?.performSegueWithIdentifier(self.segues[indexPath.row], sender: nil)
        }
        else {
            sideMenuController?.performSegueWithIdentifier(segues[indexPath.row], sender: nil)
        }
        previousIndex = indexPath
    }
}
