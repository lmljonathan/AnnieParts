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

class ProductDetailViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var imageCaroselScrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var aboutSelect: UIView!
    @IBOutlet weak var videoSelect: UIView!
    @IBOutlet weak var installSelect: UIView!
    
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
    @IBOutlet var widthOfInner: NSLayoutConstraint!
    
    @IBOutlet var changeQuantityButton: UIButton!
    @IBOutlet var addToCartButton: UIButton!
    
    private var activeTab: UIView!
    private var quantityDropDown = DropDown()
    private var quantityData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "20", "30", "40", "50", "100", "Custom"]
    private var selectedQuantity: Int! = 1
    
    var vehicleData: vehicle!
    
    private var keyboardFrame: CGRect?
    
    var productID: Int!
    var product: Product!
    
    var activeInfoView: Int! = 0
    
    // Data for the info views
    var aboutString: String!
    var videoPaths: [String]!
    var installPaths: [String]!
    
    override func viewDidLoad() {

        
        if (self.productID != nil) {
            self.setUpWithProduct(product)
            self.loadData()
        }
        self.quantityTextField.delegate = self
        self.mainScrollView.delegate = self
        
        self.setupDropDown(changeQuantityView, data: self.quantityData)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.addToCartButton.backgroundColor = UIColor.APred()
        self.navigationController?.addSideMenuButton()
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(image: UIImage(named: CONSTANTS.IMAGES.BACK_BUTTON), style: .Done, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .Done, target: self, action: #selector(self.showShoppingCart))
        activeTab = aboutSelect
        
        // mainScrollView.contentSize = CGSizeMake(self.view.frame.width, 1000)
        mainScrollView.showsVerticalScrollIndicator = true
        mainScrollView.scrollEnabled = true
        
        addNib("aboutSelect", toView: self.contentView)
        for tab in [aboutSelect, videoSelect, installSelect]{
            self.addTapGR(tab, action: #selector(ProductDetailViewController.switchTab(_:)))
        }
        
        self.fixWidthOfInnerQTY()
        super.viewDidLoad()
    }
    
    func loadData(){
        get_json_data(CONSTANTS.URL_INFO.PRODUCT_DETAIL, query_paramters: ["goods_id": self.productID], completion: { (json) in            let brief_description = json!["brief"] as! String
            
            print(json)
            let description = json!["desc"] as! String
            
            var image_paths: [String]?
            if let x = json!["thumb_url"] as? [String]{
                image_paths = x
            }
            
            self.videoPaths = json!["video"] as! [String]
            self.installPaths = json!["ins"] as! [String]
            
            self.shortDescription.text = brief_description
            self.aboutString = description
            
            if (image_paths != nil){
                self.loadImages(image_paths!, scrollView: self.imageCaroselScrollView)
            }
        })
    }
    
    private func setUpWithProduct(product: Product){
        self.productName.text = product.productName
        self.navigationItem.title = product.productName
        self.serialLabel.text = product.serialNumber
        
        if product.price != 0 && User.userRank > 1{
            self.priceLabel.text = "$" + String(product.price)
        }else{
            self.priceLabel.text = "Not Listed"
        }
        
        self.makeLabel.text = self.getMake(product.brandId)
        self.modelLabel.text = self.convertModelsToPresent(self.getModels(product.modelIDlist))
        
        if product.startYear != "0" && product.endYear != "0"{
            self.yearLabel.text = product.startYear + "-" + product.endYear
        }else{
            self.yearLabel.text = ""
        }
    }
    
    private func loadImages(urlArray: [String], scrollView: UIScrollView){
        
        scrollView.auk.settings.placeholderImage = UIImage(named: "placeholder")
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.APlightGray().colorWithAlphaComponent(0.2)
        scrollView.auk.settings.contentMode = .ScaleAspectFill
        for url in urlArray{
            scrollView.auk.show(url: "http://annieparts.com/" + url)
        }
        scrollView.auk.startAutoScroll(delaySeconds: 3.0)
    
    }
    
    @IBAction func addToCartButtonPressed(sender: AnyObject) {
        if self.quantityTextField.editing == true{
            if self.quantityTextField.text != "" && Int(self.quantityTextField.text!) != 0{
                self.selectedQuantity = Int(self.quantityTextField.text!)
                self.view.endEditing(true)
            }
        }else{
            self.addToCart()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.fixWidthOfInnerQTY()
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
    
    func switchTab(gr: UITapGestureRecognizer){
        self.activeTab = gr.view!
        
        func hideOtherTabs(){
            for view in tabView.subviews{
                if view != self.activeTab{
                    let viewLabel = view.subviews[0] as! UILabel
                    view.backgroundColor = UIColor.darkGrayColor()
                    viewLabel.textColor = UIColor.whiteColor()
                }
            }
        }
        let viewLabel = activeTab.subviews[0] as! UILabel
        activeTab.backgroundColor = UIColor.APred()
        viewLabel.textColor = UIColor.whiteColor()
        
        if contentView.subviews.count != 0{
            self.contentView.subviews[0].removeFromSuperview()
            
            switch activeTab {
            case aboutSelect:
                self.addNib("aboutSelect", toView: self.contentView)
                let view = self.contentView.subviews[0] as! aboutSelectView
                if self.aboutString != nil{
                    view.configure(self.aboutString)
                }
                self.activeInfoView = 0
            case videoSelect:
                let tableView = UITableView(frame: self.contentView.frame, style: .Plain)
                tableView.registerNib(UINib(nibName: "videoSelect", bundle: nil), forCellReuseIdentifier: "infoCell")
                self.contentView.addSubview(tableView)
                tableView.delegate = self
                tableView.dataSource = self
                tableView.scrollEnabled = false
                self.activeInfoView = 1
            case installSelect:
                let tableView = UITableView(frame: self.contentView.frame, style: .Plain)
                tableView.registerNib(UINib(nibName: "videoSelect", bundle: nil), forCellReuseIdentifier: "infoCell")
                self.contentView.addSubview(tableView)
                tableView.delegate = self
                tableView.dataSource = self
                tableView.scrollEnabled = false
                self.activeInfoView = 2
            default:
                break
            }
        }
        
        hideOtherTabs()
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
                self.fixWidthOfInnerQTY()
            }else{
                
                self.quantityTextField.text = "000"
                self.fixWidthOfInnerQTY()
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
    
    private func fixWidthOfInnerQTY(){
        self.innerQuantityView.layoutIfNeeded()
        
        let qtyWidth = quantityTextField.bounds.width
        if qtyWidth <= 10 {
            self.widthOfInner.constant = 65
        }else if qtyWidth <= 20{
            self.widthOfInner.constant = 80
        }else{
            self.widthOfInner.constant = 90
        }
        
        self.innerQuantityView.layoutIfNeeded()
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
            self.fixWidthOfInnerQTY()
            self.exitQtyEditMode()
        }
    }
    
    private func getMake(id: String) -> String{
        let id: Int! = Int(id)!
        let index = vehicleData.makeIDs.indexOf(id)
        
        return vehicleData.make[index!]
    }
    
    private func getModel(id: String) -> String{
        let id: Int! = Int(id)!
        let index = vehicleData.allModelIDs.indexOf(id)
        
        return vehicleData.allModel[index!]
    }
    
    private func getModels(idArray: [Int]) -> [String]{
        var result: [String] = []
        for id in idArray{
            result.append(self.getModel(String(id)))
        }
        return result
    }
    
    private func convertModelsToPresent(models: [String]) -> String{
        var result = ""
        for model in models{
            result += model + ", "
        }
        return result
    }
    func showShoppingCart() {
        self.performSegueWithIdentifier("showCart", sender: self)
    }

}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.activeInfoView {
        case 1:
            return self.videoPaths.count
        case 2:
            return self.installPaths.count
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let webVC = storyboard?.instantiateViewControllerWithIdentifier("webVC") as! WebViewViewController
        
        if self.activeInfoView == 1{
            let url = NSURL(string: (self.videoPaths[indexPath.row]).encodeURL())
            webVC.url = url
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if self.activeInfoView == 2{
            let url = NSURL(string: ("http://annieparts.com" + self.videoPaths[indexPath.row]).encodeURL())
            webVC.url = url
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! InfoTableViewCell
        if self.activeInfoView == 1{
            let url = NSURL(string: (self.videoPaths[indexPath.row]).encodeURL())
            cell.label.text = url?.lastPathComponent
        }else if self.activeInfoView == 2{
            let url = NSURL(string: (self.installPaths[indexPath.row]).encodeURL())
            cell.label.text = url?.lastPathComponent
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 58.0
    }
}
