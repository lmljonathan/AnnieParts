//
//  ProductDetailVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/16/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    var product: Product = Product()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBasicProductData()
        product_detail_request(product: product, product_id: product.product_id, completion: { (product) in
            self.product = product
            self.initializeDetailedProductData()
        })
    }

    func initializeBasicProductData() {

    }
    func initializeDetailedProductData() {

    }
}
