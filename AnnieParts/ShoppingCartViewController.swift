//
//  ShoppingCartViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/20/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import PopupController

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.layer.borderWidth = 1.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shoppingCartCell") as! ShoppingCartCell
        return cell
    }
    @IBAction func editItemQuantity(sender: UIButton) {
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
        productPopup.button_label = "Update"
        productPopup.closeHandler = { _ in
            popup.dismiss()
        }
        popup.show(productPopup)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
