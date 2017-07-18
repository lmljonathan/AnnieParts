//
//  ProductDetailCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/22/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import Auk
import SKPhotoBrowser

class ProductDetailCell: UITableViewCell {
    
    var product: Product!
    var parent: ProductDetailsVC!

    @IBOutlet var slideshowScrollView: UIScrollView!
    @IBOutlet var slideshowIndicator: UIActivityIndicatorView!

    @IBOutlet weak var product_name: UILabel!
    @IBOutlet weak var product_serial: UILabel!
    @IBOutlet weak var product_make: UILabel!
    @IBOutlet weak var product_years: UILabel!
    @IBOutlet weak var product_models: UILabel!
    @IBOutlet weak var product_description: UILabel!
    
    func initialize(data: Product, parent: ProductDetailsVC) {
        
        self.product = data
        self.parent = parent
        
        self.slideshowIndicator.startAnimating()

        product_name.text = data.name
        product_serial.text = data.serial_number
        product_make.text = data.make
        product_years.text = data.years
        product_models.text = data.models
        product_description.text = data.brief_description
        configureSlideshow(imageURLs: data.images)
    }
    
    func configureSlideshow(imageURLs: [String]){
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.showPhotoBrowser))
        gr.numberOfTapsRequired = 1
        self.slideshowScrollView.addGestureRecognizer(gr)
        
        self.slideshowIndicator.hidesWhenStopped = true
        self.slideshowScrollView.auk.settings.preloadRemoteImagesAround = 1
        
        print(imageURLs)
        for url in imageURLs {
            print("url of image: \(url)")
            self.slideshowScrollView.auk.show(url: url)
        }
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
        
        if (product.images.count != 0) {
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(self.slideshowScrollView.auk.currentPageIndex!)
            browser.delegate = self
            parent.present(browser, animated: true, completion: nil)
        }
    }
}

extension ProductDetailCell: SKPhotoBrowserDelegate {
    // MARK: - SKPhotoBrowserDelegate
    func didShowPhotoAtIndex(_ index: Int) {
    }
    
    func willDismissAtPageIndex(_ index: Int) {
        self.slideshowScrollView.auk.scrollToPage(atIndex: index, animated: false)
    }
    
    func didDismissAtPageIndex(_ index: Int) {
    }
}
