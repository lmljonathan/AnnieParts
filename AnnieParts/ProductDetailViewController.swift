//
//  ProductDetailViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/25/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Auk
import DropDown
import WebKit
import SwiftPhotoGallery
import Haneke

class ProductDetailViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var imageCaroselScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet var productName: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var serialLabel: UILabel!
    @IBOutlet var makeLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    @IBOutlet var shortDescription: UILabel!
    @IBOutlet var changeQuantityView: UIView!
    
    @IBOutlet var bottomBar: UIView!
    @IBOutlet var innerQuantityView: UIView!
    @IBOutlet var qty: UILabel!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var quantityImage: UIImageView!


    @IBOutlet var changeQuantityButton: UIButton!
    @IBOutlet var addToCartButton: UIButton!
    
    private var activeTab: UIView!
    private var quantityDropDown = DropDown()
    private var quantityData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "20", "30", "40", "50", "100", "Custom"]
    private var selectedQuantity: Int! = 1
    private var imagePaths: [String]?
    private var images: [UIImage] = []
    
    var vehicleData: vehicle!
    let detailedCache = Shared.imageCache
    
    private var keyboardFrame: CGRect?
    
    var productID: Int!
    var product: Product!



    private var cells = [Cell(value: "About"), Cell(value: "Video"), Cell(value: "Install")]
    private var cellsToDisplay: [Cell]! = []
    // Data for the info views
    var aboutString: String! = ""
    var videoPaths: [String]! = []
    var installPaths: [String]! = []
    
    override func viewDidLoad() {
        if (self.productID != nil) {
            self.setUpWithProduct(product)
            self.loadData()
        }
        self.quantityTextField.delegate = self
        self.mainScrollView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupDropDown(changeQuantityView, data: self.quantityData)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.addToCartButton.backgroundColor = UIColor.APred()
        configureNavBarBackButton(self.navigationController!, navItem: self.navigationItem)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .Done, target: self, action: #selector(self.showShoppingCart))
        
        mainScrollView.showsVerticalScrollIndicator = true
        mainScrollView.scrollEnabled = true

        super.viewDidLoad()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    func loadData(){
        get_json_data(CONSTANTS.URL_INFO.PRODUCT_DETAIL, query_paramters: ["goods_id": self.productID], completion: { (json) in

            let brief_description = json!["brief"] as? String ?? ""
            let description = json!["desc"] as? String ?? ""
            if let imgpaths = json!["thumb_url"] as? [String]{
                self.imagePaths = imgpaths
            }
            self.videoPaths = json!["video"] as? [String] ?? []
            self.installPaths = json!["ins"] as? [String] ?? []
            
            self.shortDescription.text = brief_description
            self.aboutString = description
            if (self.imagePaths!.count > 0){
                self.loadImages(self.imagePaths!, scrollView: self.imageCaroselScrollView)
            }

            self.cells[0].options = []
            self.cells[1].options = self.videoPaths
            self.cells[2].options = self.installPaths
            self.cellsToDisplay = self.cells.filter({$0.options.count != 0})
            print(self.cellsToDisplay)
            self.tableView.reloadData()
        })
    }
    
    private func setUpWithProduct(product: Product){
        self.productName.text = product.productName
        self.navigationItem.title = product.productName
        self.serialLabel.text = product.serialNumber
        
        if product.price != 0 && User.userRank > 1{
            self.priceLabel.text = "$" + String(product.price)
        }else{
            self.priceLabel.text = ""
        }
        
        self.makeLabel.text = product.makeText
        self.modelLabel.text = product.modelListText
        
        if product.startYear != "0" && product.endYear != "0"{
            self.yearLabel.text = product.startYear + "-" + product.endYear
        }else{
            self.yearLabel.text = ""
        }
    }
    
    private func loadImages(urlArray: [String], scrollView: UIScrollView){
        scrollView.auk.settings.placeholderImage = UIImage(named: "placeholder")
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.APlightGray().colorWithAlphaComponent(0.2)
        scrollView.auk.settings.contentMode = .ScaleAspectFit
        for url in urlArray{
            print(url)
            detailedCache.fetch(URL: NSURL(string: url)!).onSuccess { image in
                scrollView.auk.show(image: image)
                self.images.append(image)
            }.onFailure({ (error) in
                print("error with image url")
            })
        }
        scrollView.auk.startAutoScroll(delaySeconds: 3)
    }
    
    @IBAction func handleImageZoom(recognizer: UITapGestureRecognizer) {
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = UIColor.blackColor()
        gallery.pageIndicatorTintColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.whiteColor()
        
        if self.images.count == self.imagePaths?.count{
            presentViewController(gallery, animated: true, completion: nil)
        }
    }
    
    @IBAction func addToCartButtonPressed(sender: AnyObject) {
        if self.quantityTextField.editing == true{
            if self.quantityTextField.text != "" && Int(self.quantityTextField.text!) != 0{
                self.selectedQuantity = Int(self.quantityTextField.text!)
                self.view.endEditing(true)
            }
        }else{
            self.addToCart()
            self.showNotificationView("Product Added!", image: UIImage(named: "checkmark")!, completion: { (vc) in
                vc.delayDismiss(0.3)
            })
        }
    }

    @IBAction func changeQuantity(sender: AnyObject) {
        self.quantityDropDown.show()
    }
    
    func addToCart(){
        send_request(CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: ["goods_id": self.productID, CONSTANTS.JSON_KEYS.QUANTITY: self.selectedQuantity])
        self.showNotificationView("Product Added!", image: UIImage(named: "checkmark")!) { (vc) in
            vc.delayDismiss(0.2)
        }
    }
    
    func addNib(named: String, toView: UIView){
        let nibView = NSBundle.mainBundle().loadNibNamed(named, owner: self, options: nil)[0] as! UIView
        nibView.frame = toView.frame
        toView.addSubview(nibView)
    }

    private func setupDropDown(view: UIView, data: [String]){
        // The view to which the drop down will appear on
        quantityDropDown.anchorView = view // UIView or UIBarButtonItem
        quantityDropDown.direction = .Top
        quantityDropDown.cellHeight = 35
        quantityDropDown.topOffset = CGPoint(x: self.changeQuantityView.bounds.width/3, y: -53)
        quantityDropDown.textColor = UIColor.whiteColor()
        quantityDropDown.textFont = UIFont.Montserrat(15)
        quantityDropDown.backgroundColor = UIColor.APlightGray()
        
        quantityDropDown.selectionAction = { [unowned self] (index, item) in
            if item != "Custom"{
                self.selectedQuantity = Int(item)
                self.quantityTextField.text = item
            }else{
                
                self.quantityTextField.text = "000"
                self.quantityTextField.userInteractionEnabled = true
                self.quantityTextField.becomeFirstResponder()
                self.qty.hidden = true
                self.quantityTextField.text = ""
                
                self.addToCartButton.setTitle("Update Quantity", forState: .Normal)
                self.addToCartButton.titleLabel?.textAlignment = .Center
                
            }
        }
        
        // The list of items to display. Can be changed dynamically
        quantityDropDown.dataSource = data.reverse()
    }
    
    private func enterQtyEditMode(){
        self.quantityDropDown.dataSource = []
    }
    
    private func exitQtyEditMode(){
        self.quantityDropDown.dataSource = self.quantityData.reverse()
    }
    
    @IBAction func textFieldDidChange(sender: AnyObject) {
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 3 // MAX # OF DIGITS OF QUANTITY
    }


    private func addTapGR(view: UIView, action: Selector){
        let gr = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gr)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.quantityTextField.editing == true{
            self.quantityTextField.text = String(self.selectedQuantity)
        }
        self.view.endEditing(true)
        self.resignFirstResponder()
    }
    
    func unwind() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func keyboardShown(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 3, options: .CurveEaseOut, animations: {
                self.bottomBar.frame.origin.y -= keyboardSize.height
                }, completion: { (x) in
            })
            self.mainScrollView.userInteractionEnabled = false
            self.enterQtyEditMode()
        }
    }
    
    func keyboardHidden(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.bottomBar.frame.origin.y += keyboardSize.height
            self.mainScrollView.userInteractionEnabled = true
            self.addToCartButton.setTitle("Add to Cart", forState: .Normal)
            self.qty.hidden = false
            self.exitQtyEditMode()
        }
    }
    func showShoppingCart() {
        self.performSegueWithIdentifier("showCart", sender: self)
    }

}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cellsToDisplay.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.cellsToDisplay[section].expanded) {
            return self.cellsToDisplay[section].options.count + 1
        }
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let expanded = self.cellsToDisplay[indexPath.section].expanded
        if (expanded && indexPath.row > 0) {
            let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("webVC") as! WebViewViewController
            print(self.cellsToDisplay[indexPath.section].options)
            let url_string = self.cellsToDisplay[indexPath.section].options[indexPath.row - 1] as? String ?? ""
            webVC.url = url_string
            self.navigationController?.pushViewController(webVC, animated: true)
        } else {
            print(self.cellsToDisplay[indexPath.section].options)
            self.cellsToDisplay[indexPath.section].expanded = !expanded
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
        }
        self.view.setNeedsDisplay()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("infoHeaderCell") as! SearchOptionsHeaderCell
            cell.selectedOption.text = self.cellsToDisplay[indexPath.section].value
            if self.cellsToDisplay[indexPath.section].expanded {
                cell.expandedSymbol.text = "-"
            } else {
                cell.expandedSymbol.text = "+"
            }
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("infoCell") as! SearchOptionsCell
            cell.optionLabel.text = self.cellsToDisplay[indexPath.section].options[indexPath.row-1] as? String ?? ""
            return cell
        }

    }

}

extension ProductDetailViewController: SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate
{
    // MARK: SwiftPhotoGalleryDataSource Methods
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return (imagePaths?.count)!
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return images[forIndex]
    }
    
    // MARK: SwiftPhotoGalleryDelegate Methods
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
