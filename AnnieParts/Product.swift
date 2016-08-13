//
//  Product.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/10/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation

class Product {
    private var _productID: String!
    private var _productName: String!
    private var _serialNumber: String!
    private var _imagePath: String!
    private var _startYear: String!
    private var _endYear: String!
    
    var productID: String {
        return self._productID
    }
    var productName: String {
        return self._productName
    }
    var serialNumber: String {
        return self._serialNumber
    }
    var imagePath: String {
        return self._imagePath
    }
    var startYear: String {
        return self._startYear
    }
    var endYear: String {
        return self._endYear
    }
    init(productID: String, productName: String, image: String, startYear: String, endYear: String) {
        self._productID = productID
        self._productName = productName
        self._imagePath = image
        self._startYear = startYear
        self._endYear = endYear
    }
}
class ShoppingCart: Product {
    private var _quantity: Int!
    var quantity: Int {
        return self._quantity
    }
    init (productID: String, productName: String, image: String, startYear: String, endYear: String, quantity: Int) {
        super.init(productID: productID, productName: productName, image: image, startYear: startYear, endYear: endYear)
        self._quantity = quantity
    }
    func editQuantity(num: Int) {
        self._quantity = num
    }
}