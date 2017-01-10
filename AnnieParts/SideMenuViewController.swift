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
    
    private let segues = [CONSTANTS.SEGUES.SHOW_CENTER, CONSTANTS.SEGUES.SHOPPING_CART, CONSTANTS.SEGUES.ORDERS]
    private let pageOptionIcons = [CONSTANTS.IMAGES.SEARCH_ICON, CONSTANTS.IMAGES.CART_ICON, CONSTANTS.IMAGES.ORDERS_ICON]
    private let pageOptions = CONSTANTS.SIDE_MENU_OPTIONS
    
    override func viewDidLoad() {
        let index = NSIndexPath(item: 0, section: 0)
        self.tableView.cellForRow(at: index as IndexPath)?.isSelected = true
        self.userRank.text = User.getUserStatus().uppercased()
        self.name.text = User.username + " | " + User.companyName
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return segues.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: CONSTANTS.CELL_IDENTIFIERS.SIDE_MENU_CELLS)! as! MenuCellTableViewCell
        
        cell.menuLabel.text = self.pageOptions[indexPath.row]
        cell.menuIcon.image = UIImage(named: pageOptionIcons[indexPath.row])
        //cell.textLabel?.text = self.vcNames[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
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
        let storyboard = self.storyboard
        let loginVC = storyboard?.instantiateInitialViewController() as! LoginVC
        self.present(loginVC, animated: true, completion: nil)
    }
}
