//
//  ShoppingCartViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/20/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Presentr

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddProductModalView {

    @IBOutlet weak var tableView: UITableView!
    private var shoppingCart: [Product]!
    override func viewDidLoad() {
        if self.shoppingCart == nil {
            self.shoppingCart = []
        }
        self.navigationController?.addSideMenuButton()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delaysContentTouches = false
        for view in self.tableView.subviews {
            if view is UIScrollView {
                (view as? UIScrollView)!.delaysContentTouches = false
                break
            }
        }
        //loadData()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        get_json_data("shoppingCart", query_paramters: [:]) { (json) in
            if let products = json!["shopping_cart"] as? NSArray {
                for product in products {
                    let id = String(product["goods_id"] as! Int)
                    let name = product["goods_name"] as! String
                    let img = product["goods_img"] as! String
                    self.shoppingCart.append(Product(productID: id, productName: name, image: img))
                }
                self.tableView.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingCart.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shoppingCartCell") as! ShoppingCartCell
        cell.configureCell()
        cell.changeQuantityButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.changeQuantityButton.addTarget(self, action: #selector(ShoppingCartViewController.editItemQuantity(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
    @IBAction func editItemQuantity(sender: UIButton) {
        let width = ModalSize.Default
        let height = ModalSize.Custom(size: 200)
        let center = ModalCenterPosition.TopCenter
        let presenter = Presentr(presentationType: .Custom(width: width, height: height, center: center))
        presenter.blurBackground = true
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("popup") as! AddProductModalViewController
        vc.delegate = self
        vc.id = "slkdfjklds"
        vc.buttonString = "Update"
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        
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
