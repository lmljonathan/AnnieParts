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
import Haneke
import SKPhotoBrowser

class ProductDetailViewController: UIViewController, UIScrollViewDelegate, SKPhotoBrowserDelegate, AddProductModalView {
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




    @IBOutlet var addToCartButton: UIButton!

    private var imagePaths: [String]?
    private var images: [UIImage] = []
    
    var vehicleData: vehicle!
    let detailedCache = Shared.imageCache
    var productID: Int!
    var product: Product!



    private var cells = [Cell(value: "规格"), Cell(value: "视频"), Cell(value: "安装")]
    private var cellsToDisplay: [Cell]! = []
    // Data for the info views
    private var aboutString: String! = ""
    private var videoPaths: [String]! = []
    private var videoTitles: [String]! = []
    private var installPaths: [String]! = []
    private var installTitles: [String]! = []

    override func viewDidLoad() {
        if (self.productID != nil) {
            self.setUpWithProduct(product)
            self.loadData()
        }
        self.mainScrollView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureNavBarBackButton(self.navigationController!, navItem: self.navigationItem)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .Done, target: self, action: #selector(self.showShoppingCart))
        
        mainScrollView.showsVerticalScrollIndicator = true
        mainScrollView.scrollEnabled = true

        super.viewDidLoad()
    }
    func loadData(){
        self.cellsToDisplay.removeAll()
        self.videoPaths.removeAll()
        self.videoTitles.removeAll()
        self.installPaths.removeAll()
        self.installTitles.removeAll()
        get_json_data(CONSTANTS.URL_INFO.PRODUCT_DETAIL, query_paramters: ["goods_id": self.productID], completion: { (json) in

            let brief_description = json!["brief"] as? String ?? ""
            let description = json!["desc"] as? String ?? ""
            if let imgpaths = json!["thumb_url"] as? [String]{
                self.imagePaths = imgpaths
            }
            if let videos = json!["video"] as? [NSDictionary] {
                for video in videos {
                    self.videoTitles.append(video["title"] as? String ?? "")
                    self.videoPaths.append(video["href"] as? String ?? "")
                }
            }
            if let install_files = json!["ins"] as? [NSDictionary] {
                for file in install_files {
                    self.installTitles.append(file["title"] as? String ?? "")
                    self.installPaths.append(file["href"] as? String ?? "")
                }
            }
            
            self.shortDescription.text = brief_description
            self.aboutString = description
            if (self.imagePaths!.count > 0){
                self.loadImages(self.imagePaths!, scrollView: self.imageCaroselScrollView)
            }

            self.cells[0].options = []

            self.cells[1].options = self.videoTitles
            self.cells[2].options = self.installTitles

            self.cells[1].option_ids = self.videoPaths
            self.cells[2].option_ids = self.installPaths
            self.cellsToDisplay = self.cells.filter({$0.options.count != 0})
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
        if self.images.count == self.imagePaths?.count{
            
            var SKImages = [SKPhoto]()
            for image in self.images{
                let photo = SKPhoto.photoWithImage(image)
                SKImages.append(photo)
            }
            
            let browser = SKPhotoBrowser(photos: SKImages)
            browser.displayCloseButton = false
            browser.initializePageIndex(self.imageCaroselScrollView.auk.currentPageIndex!)
            browser.delegate = self
            browser.enableSingleTapDismiss = true
            
            presentViewController(browser, animated: true, completion: {})
            //presentViewController(gallery, animated: true, completion: nil)
        }
    }
    
    @IBAction func addToCartButtonPressed(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self

        vc.name = product.productName
        vc.id = String(product.productID)
        vc.sn = product.serialNumber
        vc.buttonString = CONSTANTS.ADD_TO_CART_LABEL
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request(CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: ["goods_id": self.productID, CONSTANTS.JSON_KEYS.QUANTITY: quantity])
        self.showNotificationView("Product Added!", image: UIImage(named: "checkmark")!) { (vc) in
            vc.delayDismiss(0.2)
        }
    }

    func unwind() {
        self.navigationController?.popViewControllerAnimated(true)
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
        return 0.001
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let expanded = self.cellsToDisplay[indexPath.section].expanded
        if (expanded && indexPath.row > 0) {
            let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("webVC") as! WebViewViewController
            let url_string = self.cellsToDisplay[indexPath.section].option_ids[indexPath.row - 1] as? String ?? ""
            webVC.url = url_string
            self.navigationController?.pushViewController(webVC, animated: true)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        } else {
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