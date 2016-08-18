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
    private var _brandID: String!
    private var _price: Double!
    
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
    var brandId: String {
        return self._brandID
    }
    var price: Double {
        return self._price
    }
    init(productID: String, productName: String, image: String, serialNumber: String, startYear: String, endYear: String, brandID: String, price: Double) {
        self._productID = productID
        self._productName = productName
        self._imagePath = image
        self._startYear = startYear
        self._endYear = endYear
        self._brandID = brandID
        self._serialNumber = serialNumber
        self._price = price
    }
}
class ShoppingCart: Product {
    private var _quantity: Int!
    var quantity: Int {
        return self._quantity
    }
    init (productID: String, productName: String, image: String, serialNumber: String, startYear: String, endYear: String, brandID: String, price: Double, quantity: Int) {
        super.init(productID: productID, productName: productName, image: image, serialNumber: serialNumber, startYear: startYear, endYear: endYear, brandID: brandID, price: price)
        self._quantity = quantity
    }
    func editQuantity(num: Int) {
        self._quantity = num
    }
}