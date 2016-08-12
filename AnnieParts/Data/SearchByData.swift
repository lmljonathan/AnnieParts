//
//  SearchByData.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/19/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation

struct brand{
    var options: [String]! = []
    var optionsIDs: [Int]! = []
}
struct vehicle{
    var year: [String!] = []
    var yearIDs: [Int]! = []
    
    var make: [String]! = []
    var makeIDs: [Int]! = []
    
    var model: [String]! = []
    var modelIDs: [Int]! = []
}

struct product{
    var products: [String]! = []
    var productsIDs: [Int]! = []
}