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
    
    // Stores all models retrieved by server
    var allModel: [String]! = []
    var allModelIDs: [Int]! = []
    var allModelPIDs: [Int]! = []
    
    // Stores only models who match PID of make selected
    var model: [String]! = []
    var modelIDs: [Int]! = []
    var modelPIDs: [Int]! = []
}

struct product{
    var products: [String]! = []
    var productsIDs: [Int]! = []
}