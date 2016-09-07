//
//  OrdersTableViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 9/7/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController {
    
    enum OrderType {
        case Customer
        case Unprocessed
        case Processed
    }
    
    enum UserRank {
        case Browser
        case Dealer
    }
    
    var accountType: UserRank!
    var sectionTitles = ["Customer Orders", "Unprocessed Orders", "Processed Orders"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setUserRank()
        //self.loadData()
        //self.tableView.registerNib(UINib(nibName: "OrderCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL)
        //self.tableView.reloadData()
    }
    
    private func setUserRank() {
        if User.userRank == 1{
            accountType = .Browser
        }else{
            accountType = .Dealer
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sectionTitles
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.ORDER_CELL, forIndexPath: indexPath) as! OrderTableViewCell
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 117.0
    }

   }
