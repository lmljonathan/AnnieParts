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
    
    @IBOutlet weak var product_name: UILabel!
    @IBOutlet weak var product_serial_number: UILabel!
    @IBOutlet weak var product_make: UILabel!
    @IBOutlet weak var product_years: UILabel!
    @IBOutlet weak var product_models: UILabel!

    var product: Product = Product()

    let autoScrollDelay: TimeInterval = 3.0 // adjust the number of seconds between scrolling
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBasicProductData()
        self.slideshowIndicator.startAnimating()
        product_detail_request(product: product, product_id: product.product_id, completion: { (product) in
            self.product = product
            self.initializeDetailedProductData()
        })
    }

    func initializeBasicProductData() {
        product_name.text = product.name
        product_serial_number.text = product.serial_number
        product_make.text = product.make
        product_years.text = product.years
        product_models.text = product.models
    }
    
    func initializeDetailedProductData() {
        configureSlideshow(with: product.images)
    }
    
    func configureSlideshow(with imageURLs: [String]){
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.showPhotoBrowser))
        gr.numberOfTapsRequired = 1
        self.slideshowScrollView.addGestureRecognizer(gr)
        
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
        var images: [SKPhoto] {
            var current_images = self.slideshowScrollView.auk.images.map({SKPhoto.photoWithImage($0)})
            for index in (current_images.count)..<self.product.images.count {
                let photo = SKPhoto.photoWithImageURL(self.product.images[index])
                photo.shouldCachePhotoURLImage = false
                current_images.append(photo)
            }
            return current_images
        }
        
        if product.images.count != 0 {
            let browser = SKPhotoBrowser(photos: images)
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
        self.slideshowScrollView.auk.startAutoScroll(delaySeconds: autoScrollDelay)
    }
    
}
