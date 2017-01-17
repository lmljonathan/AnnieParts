//
//  ProductDetailVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/16/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import Auk

class ProductDetailVC: UIViewController {

    @IBOutlet var slideshowScrollView: UIScrollView!
    @IBOutlet var slideshowIndicator: UIActivityIndicatorView!
    
    var product: Product = Product()
    let autoScrollDelay: TimeInterval = 3.0 // adjust the number of seconds between scrolling
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBasicProductData()
        
        self.slideshowIndicator.startAnimating()
    
        product_detail_request(product: product, product_id: product.product_id, completion: { (product) in
            self.product = product
            self.initializeDetailedProductData()
            
            self.configureSlideshow(with: product.images)
        })
    }

    func initializeBasicProductData() {

    }
    
    func initializeDetailedProductData() {

    }
    
    func configureSlideshow(with imageURLs: [String]){
        func setupGR(){
            let gr = UITapGestureRecognizer(target: self, action: #selector(self.showPhotoBrowser))
            gr.numberOfTapsRequired = 1
            self.slideshowScrollView.addGestureRecognizer(gr)
        }
        setupGR()
        
        self.slideshowIndicator.hidesWhenStopped = true
        self.slideshowScrollView.auk.settings.preloadRemoteImagesAround = 1
        
        for url in imageURLs {
            print("url of image: \(url)")
            self.slideshowScrollView.auk.show(url: url)
        }
    
        self.slideshowScrollView.auk.startAutoScroll(delaySeconds: autoScrollDelay)
        
        self.slideshowIndicator.stopAnimating()
    }
    
    internal func showPhotoBrowser() {
        func getImages() -> [SKPhoto] {
            // from already loaded in auk
            var images = self.slideshowScrollView.auk.images.map({SKPhoto.photoWithImage($0)})
            
            // from url not loaded already
            for index in (images.count)..<self.product.images.count {
                let photo = SKPhoto.photoWithImageURL(self.product.images[index])
                photo.shouldCachePhotoURLImage = false
                images.append(photo)
            }
            
            return images
        }
        
        if product.images.count != 0 {
            let browser = SKPhotoBrowser(photos: getImages())
            browser.initializePageIndex(self.slideshowScrollView.auk.currentPageIndex!)
            browser.delegate = self
            self.slideshowScrollView.auk.stopAutoScroll()
            self.present(browser, animated: true, completion: nil)
        }
    }
}

extension ProductDetailVC: SKPhotoBrowserDelegate {
    // MARK: - SKPhotoBrowserDelegate
    func didShowPhotoAtIndex(_ index: Int) {
        // when photo will be shown
    }
    
    func willDismissAtPageIndex(_ index: Int) {
        // when PhotoBrowser will be dismissed
        self.slideshowScrollView.auk.scrollToPage(atIndex: index, animated: false)
    }
    
    func didDismissAtPageIndex(_ index: Int) {
        // when PhotoBrowser did dismissed
        self.slideshowScrollView.auk.startAutoScroll(delaySeconds: self.autoScrollDelay)
    }
    
}
