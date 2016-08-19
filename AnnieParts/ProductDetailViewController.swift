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

class ProductDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var imageCaroselScrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var aboutSelect: UIView!
    @IBOutlet weak var videoSelect: UIView!
    @IBOutlet weak var installSelect: UIView!
    @IBOutlet weak var docsSelect: UIView!
    
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
    
    private var keyboardFrame: CGRect?
    
    var productID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.productID != nil) {
            get_json_data(CONSTANTS.URL_INFO.PRODUCT_DETAIL, query_paramters: ["goods_id": self.productID], completion: { (json) in
                let name = json![CONSTANTS.JSON_KEYS.NAME] as! String
                let sn = json![CONSTANTS.JSON_KEYS.SERIAL_NUMBER] as! String
                let price = json!["shop_price"] as! String
                let startYear = json![CONSTANTS.JSON_KEYS.START_YEAR] as! String
                let endYear = json![CONSTANTS.JSON_KEYS.END_YEAR] as! String
                let brief_description = json!["brief"] as! String
                let description = json!["desc"] as! String
                let image_paths = json!["thumb_url"] as! NSArray
                
            })
        }
        self.quantityTextField.delegate = self
        
        self.setupDropDown(changeQuantityView, data: self.quantityData)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        self.addToCartButton.backgroundColor = UIColor.APred()
        self.navigationController?.addSideMenuButton()
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(image: UIImage(named: CONSTANTS.IMAGES.BACK_BUTTON), style: .Done, target: self.navigationController, action: #selector(self.navigationController?.popViewControllerAnimated(_:))), atIndex:0)
        activeTab = aboutSelect
        
        // mainScrollView.contentSize = CGSizeMake(self.view.frame.width, 1000)
        mainScrollView.showsVerticalScrollIndicator = true
        mainScrollView.scrollEnabled = true
        imageCaroselScrollView.auk.settings.placeholderImage = UIImage(named: "placeholder")
        
        // Show remote images
        imageCaroselScrollView.auk.settings.pageControl.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        imageCaroselScrollView.auk.show(url: "https://bit.ly/auk_image")
        imageCaroselScrollView.auk.show(url: "https://bit.ly/moa_image")
        
        addNib("aboutSelect", toView: self.contentView)
        for tab in [aboutSelect, videoSelect, installSelect, docsSelect]{
            self.addTapGR(tab, action: #selector(ProductDetailViewController.switchTab(_:)))
        }
        
        self.fixWidthOfInnerQTY()
    }
    
    override func viewDidLayoutSubviews() {
        self.fixWidthOfInnerQTY()
    }
    
    @IBAction func changeQuantity(sender: AnyObject) {
        self.quantityDropDown.show()
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
        activeTab.backgroundColor = UIColor.whiteColor()
        viewLabel.textColor = UIColor.darkGrayColor()
        
        if contentView.subviews.count != 0{
            self.contentView.subviews[0].removeFromSuperview()
            
            switch activeTab {
            case aboutSelect:
                self.addNib("aboutSelect", toView: self.contentView)
                let view = self.contentView.subviews[0] as! aboutSelectView
                view.configure("There is no information at the moment.")
            case videoSelect:
                self.addNib("videoSelect", toView: self.contentView)
            case installSelect:
                self.addNib("aboutSelect", toView: self.contentView)
            case docsSelect:
                self.addNib("aboutSelect", toView: self.contentView)
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
        //quantityDropDown.bottomOffset = CGPoint(x: 0, y:view.bounds.height)
        quantityDropDown.cellHeight = 35
        quantityDropDown.topOffset = CGPoint(x: self.changeQuantityView.bounds.width/3, y: -53)
        quantityDropDown.textColor = UIColor.whiteColor()
        quantityDropDown.textFont = UIFont.Montserrat(15)
        quantityDropDown.backgroundColor = UIColor.APlightGray()
        
        quantityDropDown.selectionAction = { [unowned self] (index, item) in
            if item != "Custom"{
                self.quantityTextField.text = item
                self.fixWidthOfInnerQTY()
            }else{
                
                self.quantityTextField.text = "00000"
                self.fixWidthOfInnerQTY()
                self.quantityTextField.userInteractionEnabled = true
                self.quantityTextField.becomeFirstResponder()
                self.qty.hidden = true
                self.quantityTextField.text = ""
                
                self.bottomBar.transform = CGAffineTransformMakeTranslation(0, -271)
            }
        }
        
        // The list of items to display. Can be changed dynamically
        quantityDropDown.dataSource = data.reverse()
    }
    
    @IBAction func textFieldDidChange(sender: AnyObject) {
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 5 // Bool
    }


    private func addTapGR(view: UIView, action: Selector){
        let gr = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gr)
    }
    
    private func fixWidthOfInnerQTY(){
        self.innerQuantityView.layoutIfNeeded()
        
        let qtyWidth = quantityTextField.bounds.width
        if qtyWidth <= 10 {
            self.widthOfInner.constant = 70
        }else if qtyWidth <= 20{
            self.widthOfInner.constant = 80
        }else{
            self.widthOfInner.constant = 85
        }
        
        self.innerQuantityView.layoutIfNeeded()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.resignFirstResponder()
        self.quantityTextField.resignFirstResponder()
    }
    
    func unwind() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        print("keyboardFrame: \(keyboardFrame)")
        self.keyboardFrame = keyboardFrame
    }
    
    

}
