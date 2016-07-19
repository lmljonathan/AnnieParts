//
//  SearchByTableViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/17/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import DropDown

class SearchByTableViewController: UITableViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var oneView: UIView!
    @IBOutlet weak var twoView: UIView!
    @IBOutlet weak var threeView: UIView!
    
    // MARK: - Variables
    private var dropDown = DropDown()
    private var data = [["BRAND"], ["YEAR", "MAKE", "MODEL"], ["PRODUCT TYPE"]]
    private var activeIndex = 0

    // MARK: - View Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = [oneView: "searchByBrand:", twoView: "searchByCar:", threeView: "searchByProduct:"]
        
        for view in options.keys{
            self.addTapGR(view, action: Selector(options[view]!))
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.navigationBarHidden = false
    }

    // MARK: - Table View Delegate Functions

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data[activeIndex].count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[activeIndex][section]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("selectCell", forIndexPath: indexPath)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        switch indexPath.row {
//        case 0:
//            setupDropDown((tableView.cellForRowAtIndexPath(indexPath)?.contentView)!)
//            dropDown.show()
//        default:
//            break
//        }
    }
    
    // MARK: - Main Functions
    func searchByBrand(gr: UITapGestureRecognizer){
        self.selectTab(0)
    }
    
    func searchByCar(gr: UITapGestureRecognizer){
        self.selectTab(1)
    }
    
    func searchByProduct(gr: UITapGestureRecognizer){
        self.selectTab(2)
    }
    
    func setupDropDown(view: UIView){
        // The view to which the drop down will appear on
        dropDown.anchorView = view // UIView or UIBarButtonItem
        dropDown.direction = .Bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:view.bounds.height)
        dropDown.cellHeight = 44
        dropDown.backgroundColor = UIColor.lightGrayColor()
        
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
    }
    
    private func selectTab(index: Int){
        let tabViews = [oneView, twoView, threeView]
        
        for x in 0..<3{
            if x != index{
                (tabViews[x]).backgroundColor = UIColor.whiteColor()
            }else{
                (tabViews[x]).backgroundColor = UIColor.lightGrayColor()
            }
        }
    }
    
    private func addTapGR(view: UIView, action: Selector){
        let gr = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gr)
    }
    
}


