//
//  SearchByData.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/19/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation

struct brand{
    static var options: [String]! = []
    static var optionsIDs: [Int]! = []
}
struct vehicle{
    static var year: [String!] = []
    static var yearIDs: [Int]! = []
    
    static var make: [String]! = []
    static var makeIDs: [Int]! = []
    
    // Stores all models retrieved by server
    static var allModel: [String]! = []
    static var allModelIDs: [Int]! = []
    static var allModelPIDs: [Int]! = []
    
    // Stores only models who match PID of make selected
    static var model: [String]! = []
    static var modelIDs: [Int]! = []
}

struct product{
    static var products: [String]! = []
    static var productsIDs: [Int]! = []
}

func getMake(id: Int) -> String {
    let index = vehicle.makeIDs.indexOf(id)
    return vehicle.make[index!] ?? ""
}
func getModel(id: Int) -> String {
    let index = vehicle.allModelIDs.indexOf(id)
    print(id)
    print(vehicle.allModelIDs)
    print(index)
    return vehicle.allModel[index!] ?? ""
}
func getListOfModels(model_ids: [Int]) -> String {
    var model_string = ""
    for id in model_ids {
        model_string += getModel(id) + ", "
    }
    return model_string
}
func configureModelList(selectedMake: String) {
    vehicle.model.removeAll()
    vehicle.modelIDs.removeAll()
    let indexOfMake = vehicle.make.indexOf(selectedMake)
    let make_PID = vehicle.makeIDs[indexOfMake!]
    print(make_PID)
    for index in 0...vehicle.allModelPIDs.count-1 {
        let pid = vehicle.allModelPIDs[index]
        if pid == make_PID {
            vehicle.model.append(vehicle.allModel[index])
            vehicle.modelIDs.append(vehicle.allModelIDs[index])
        }
    }
    print(vehicle.model)
}