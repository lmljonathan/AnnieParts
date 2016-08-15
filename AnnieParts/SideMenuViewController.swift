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
    
    private let segues = [CONSTANTS.SEGUES.SHOW_CENTER, CONSTANTS.SEGUES.SHOPPING_CART]
    private let pageOptionIcons = [CONSTANTS.IMAGES.SEARCH_ICON, CONSTANTS.IMAGES.CART_ICON]
    private let pageOptions = CONSTANTS.SIDE_MENU_OPTIONS
    override func viewDidLoad() {
        let index = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.cellForRowAtIndexPath(index)?.selected = true
        self.userRank.text = User.getUserStatus().uppercaseString
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return segues.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CONSTANTS.CELL_IDENTIFIERS.SIDE_MENU_CELLS)! as! MenuCellTableViewCell
        
        cell.menuLabel.text = self.pageOptions[indexPath.row]
        cell.menuIcon.image = UIImage(named: pageOptionIcons[indexPath.row])
        //cell.textLabel?.text = self.vcNames[indexPath.row]
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
        sideMenuController?.performSegueWithIdentifier(CONSTANTS.SEGUES.LOGIN, sender: nil)
    }
}
