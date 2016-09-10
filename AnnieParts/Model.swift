//
//  Product.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/10/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation

struct User {
    static var userRank = -1
    static var username = ""
    static var companyName = ""
    static func setUserRank(rank: Int) {
        if (rank < 1 || rank > 4) {
            print("this rank does not exist")
        }
        else {
            userRank = rank
        }
    }

    static func getUserStatus() -> String {
        if (userRank != -1) {
            return CONSTANTS.USER_RANKS[userRank]!
        }
        return ""
    }
}

class Product {
    private var _productID: String!
    private var _productName: String!
    private var _serialNumber: String!
    private var _imagePath: String!
    private var _startYear: String!
    private var _endYear: String!
    private var _brandID: Int!
    private var _price: Double!
    private var _modelID: Int!
    private var _modelIDlist: [Int]!
    private var _modelListText: String!
    private var _makeText: String!
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
    var brandId: Int {
        return self._brandID
    }
    var price: Double {
        return self._price
    }
    var modelID: Int{
        return self._modelID
    }
    var modelIDlist: [Int]{
        return self._modelIDlist
    }
    var modelListText: String {
        return self._modelListText
    }
    var makeText: String {
        return self._makeText
    }
    func setModelListText(text: String) {
        self._modelListText = text
    }
    func setMakeText(text: String) {
        self._makeText = text
    }
    init(productID: String, productName: String, image: String, serialNumber: String, startYear: String, endYear: String, brandID: Int, price: Double, modelID: Int, modelIDlist: [Int]) {
        self._productID = productID
        self._productName = productName
        self._imagePath = image
        self._startYear = startYear
        self._endYear = endYear
        self._brandID = brandID
        self._serialNumber = serialNumber
        self._price = price
        self._modelID = modelID
        self._modelIDlist = modelIDlist
        self._modelListText = ""
        self._makeText = ""
    }
}
class ShoppingCart: Product {
    private var _quantity: Int!
    var quantity: Int {
        return self._quantity
    }
    init (productID: String, productName: String, image: String, serialNumber: String, startYear: String, endYear: String, brandID: Int, price: Double, quantity: Int, modelID: Int, modelIDlist: [Int]!) {
        super.init(productID: productID, productName: productName, image: image, serialNumber: serialNumber, startYear: startYear, endYear: endYear, brandID: brandID, price: price, modelID: modelID, modelIDlist: modelIDlist)
        self._quantity = quantity
    }
    func editQuantity(num: Int) {
        self._quantity = num
    }
}

class Order {
    private var _addTime: String!
    private var _userID: Int!
    private var _totalPrice: Double!
    //private var _numItems: Int!
    private var _sn: String!
    private var _id: Int!
    
    var addTime: String! {
        return self._addTime
    }
    
    var userID: Int! {
        return self._userID
    }
    
    var totalPrice: Double! {
        return self._totalPrice
    }
    
//    var numItems: Int! {
//        return self._numItems
//    }
    
    var sn: String! {
        return self._sn
    }
    
    var id: Int! {
        return self._id
    }
    
    init(addTime: String, userID: Int, totalPrice: Double, sn: String, id: Int) {
        self._addTime = addTime
        self._userID = userID
        self._totalPrice = totalPrice
        //self._numItems = numItems
        self._sn = sn
        self._id = id
    }
}

class ProcessedOrder: Order {
    
    private var _status: String!
    
    var status: String!{
        return self._status
    }
    
    init(addTime: String, userID: Int, totalPrice: Double, sn: String, id: Int, status: String){
        super.init(addTime: addTime, userID: userID, totalPrice: totalPrice, sn: sn, id: id)
        self._status = status
    }
}