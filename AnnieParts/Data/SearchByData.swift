//
//  SearchByData.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/19/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation

struct brand{
    var options = ["Wolf",
                  "Sparrow"]
    var optionsIDs = []
}

struct vehicle{
    var year = ["2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016"]
    var yearIDs = []
    
    var make = ["Toyota", "Acura", "BMW"]
    var makeIDs = []
    
    var model = [""]
    var modelIDs = []
}

struct product{
    var products = [""]
    var productsIDs = []
}