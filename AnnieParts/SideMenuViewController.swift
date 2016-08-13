//
//  SideMenuViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/12/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userRank: UILabel!
    @IBOutlet weak var name: UILabel!
    
    private let segues = ["showCenterSearch", "showCenterShoppingCart"]
    private let vcNames = ["Search", "Shopping Cart"]
    private var previousIndex: NSIndexPath?
    override func viewDidLoad() {
        self.userRank.text = User.getUserStatus()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        super.viewDidLoad()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return segues.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell")!
        cell.textLabel?.text = self.vcNames[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sideMenuController?.performSegueWithIdentifier(segues[indexPath.row], sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func buttonLogout(sender: UIButton) {
        logout()
        sideMenuController?.performSegueWithIdentifier("showCenterLogin", sender: nil)
    }
}
