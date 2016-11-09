//
//  ProductDetailViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/25/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Auk
import WebKit
import Haneke
import SKPhotoBrowser

class ProductDetailViewController: UIViewController, SKPhotoBrowserDelegate, AddProductModalView {


    @IBOutlet weak var tableView: UITableView!
    private var imagePaths: [String]! = []
    private var images: [UIImage] = []
    
    var vehicleData: vehicle!
    let detailedCache = Shared.imageCache
    var productID: Int!
    var product: Product!

    fileprivate var cells = [Cell(value: "规格"), Cell(value: "视频"), Cell(value: "安装")]
    fileprivate var cellsToDisplay: [Cell]! = []

    private var aboutString: String! = ""
    private var brief_description: String! = ""
    private var videoPaths: [String]! = []
    private var videoTitles: [String]! = []
    private var installPaths: [String]! = []
    private var installTitles: [String]! = []

    override func viewDidLoad() {
        configureNavBarBackButton(sender: self.navigationController!, navItem: self.navigationItem)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .done, target: self, action: #selector(self.showShoppingCart))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.loadData()
        super.viewDidLoad()
    }

    private func decodeString(encodedString:String) -> NSAttributedString?
    {
        let encodedData = encodedString.data(using: String.Encoding.utf8)!
        do {
            return try NSAttributedString(data: encodedData, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    func initializeUI(cell: ProductDetailMainInfoCell) {
        cell.isUserInteractionEnabled = false
        cell.productName.text = self.product.productName
        cell.manufacturer.text = self.product.makeText
        cell.model.text = self.product.modelListText
        cell.serialNumber.text = self.product.serialNumber
        cell.brief_description.text = self.brief_description
        if (self.product.startYear != "0" && self.product.endYear != "0"){
            cell.year.text = self.product.startYear + "-" + self.product.endYear
        } else {
            cell.year.text = ""
        }
        if product.price != 0 && User.userRank > 1{
            cell.price.text = "$" + String(product.price)
        }else{
            cell.price.text = ""
        }
        let scrollView = cell.photoBrowserView
        scrollView?.auk.settings.placeholderImage = UIImage(named: "placeholder")
        scrollView?.auk.settings.pageControl.backgroundColor = UIColor.APlightGray().withAlphaComponent(0.2)
        scrollView?.auk.settings.contentMode = .scaleAspectFit
        for url in self.imagePaths{
            print(url)
            detailedCache.fetch(URL: NSURL(string: url)! as URL).onSuccess { image in
                scrollView?.auk.show(image: image)
                self.images.append(image)
                }.onFailure({ (error) in
                    print("error with image url")
                })
        }
        scrollView?.auk.startAutoScroll(delaySeconds: 3)
    }
    func loadData(){
        self.cellsToDisplay.removeAll()
        self.videoPaths.removeAll()
        self.videoTitles.removeAll()
        self.installPaths.removeAll()
        self.installTitles.removeAll()
        get_json_data(query_type: CONSTANTS.URL_INFO.PRODUCT_DETAIL, query_paramters: ["goods_id": self.productID as AnyObject], completion: { (json) in
            self.brief_description = json!["brief"] as? String ?? ""
            let description_html = json!["desc"] as? String ?? ""
            if let imgpaths = json!["thumb_url"] as? [String]{
                self.imagePaths = imgpaths
            }
            if let videos = json!["video"] as? [[String: AnyObject]] {
                for video in videos {
                    self.videoTitles.append(video["title"] as! String)
                    self.videoPaths.append(video["href"] as! String)
                }
            }
            if let install_files = json!["ins"] as? [NSDictionary] {
                for file in install_files {
                    self.installTitles.append(file["title"] as? String ?? "")
                    self.installPaths.append(file["href"] as? String ?? "")
                }
            }
            self.aboutString = self.decodeString(encodedString: description_html)!.string
            self.cells[0].options = [self.aboutString]
            self.cells[1].options = self.videoTitles as [String]
            self.cells[2].options = self.installTitles as [String]
            self.cells[1].option_paths = self.videoPaths as [String]
            self.cells[2].option_paths = self.installPaths as [String]
            self.cellsToDisplay = self.cells.filter({$0.options.count != 0})
            self.tableView.reloadData()
        })
    }
    private func loadImages(urlArray: [String], scrollView: UIScrollView){
        scrollView.auk.settings.placeholderImage = UIImage(named: "placeholder")
        scrollView.auk.settings.pageControl.backgroundColor = UIColor.APlightGray().withAlphaComponent(0.2)
        scrollView.auk.settings.contentMode = .scaleAspectFit
        for url in urlArray{
            print(url)
            detailedCache.fetch(URL: NSURL(string: url)! as URL).onSuccess { image in
                scrollView.auk.show(image: image)
                self.images.append(image)
            }.onFailure({ (error) in
                print("error with image url")
            })
        }
        scrollView.auk.startAutoScroll(delaySeconds: 3)
    }

//    @IBAction func handleImageZoom(recognizer: UITapGestureRecognizer) {
//        if self.images.count == self.imagePaths?.count{
//            
//            var SKImages = [SKPhoto]()
//            for image in self.images{
//                let photo = SKPhoto.photoWithImage(image)
//                SKImages.append(photo)
//            }
//            let browser = SKPhotoBrowser(photos: SKImages)
//            //browser.displayCloseButton = false
//            browser.initializePageIndex(self.imageCaroselScrollView.auk.currentPageIndex!)
//            browser.delegate = self
//            //browser.enableSingleTapDismiss = true
//            
//            presentViewController(browser, animated: true, completion: {})
//            //presentViewController(gallery, animated: true, completion: nil)
//        }
//    }

    @IBAction func addToCartButtonPressed(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: CONSTANTS.VC_IDS.ADD_PRODUCT_POPUP) as! AddProductModalViewController
        vc.delegate = self
        vc.name = product.productName
        vc.id = String(product.productID)
        vc.sn = product.serialNumber
        vc.buttonString = CONSTANTS.ADD_TO_CART_LABEL
        customPresentViewController(initializePresentr(), viewController: vc, animated: true, completion: nil)
    }
    func returnIDandQuantity(id: String, quantity: Int) {
        send_request(query_type: CONSTANTS.URL_INFO.ADD_TO_CART, query_paramters: ["goods_id": self.productID as AnyObject, CONSTANTS.JSON_KEYS.QUANTITY: quantity as AnyObject])
        self.showNotificationView(message: "Product Added!", image: UIImage(named: "checkmark")!) { (vc) in
            vc.delayDismiss(seconds: 0.2)
        }
    }
    func unwind() {
        self.navigationController?.popViewController(animated: true)
    }
    func showShoppingCart() {
        self.performSegue(withIdentifier: "showCart", sender: self)
    }

}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.cellsToDisplay.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section != 0 && self.cellsToDisplay[section-1].expanded) {
            return self.cellsToDisplay[section-1].options.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 370.0
        }
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section - 1
        let expanded = self.cellsToDisplay[section].expanded
        if (expanded && indexPath.row > 0 && section > 0) {
            let webVC = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as! WebViewViewController
            let url_string = self.cellsToDisplay[section].option_paths[indexPath.row - 1]
            webVC.url = url_string
            self.navigationController?.pushViewController(webVC, animated: true)
            
            self.tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        }
        else {
            self.cellsToDisplay[section].expanded = !expanded
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .fade)
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0 && indexPath.row == 0) {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "mainInfoCell") as! ProductDetailMainInfoCell
            self.initializeUI(cell: cell)
            return cell
        }
        else {
            let section = indexPath.section - 1
            if (indexPath.row == 0) {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "infoHeaderCell") as! SearchOptionsHeaderCell
                cell.selectedOption.text = self.cellsToDisplay[section].value
                if self.cellsToDisplay[indexPath.section-1].expanded {
                    cell.expandedSymbol.text = "-"
                } else {
                    cell.expandedSymbol.text = "+"
                }
                return cell
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "infoCell") as! SearchOptionsCell
                cell.optionLabel.text = self.cellsToDisplay[section].options[indexPath.row-1]
                return cell
            }
        }
    }
}
