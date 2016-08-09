//
//  DataHandler.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/28/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import SwiftyJSON
import Alamofire

import Foundation

var id_reference_list = []
var year_list = []
var manufacturer_list  = []
var model_list = []
var product_type_list = []

private let BASE_URL = "http://www.annieparts.com/"
private let query_type_url = [
    "config": "appGetCfg.php",
    "catalog": "appSearch.php",
    "keyword": "appSearchKeyword.php",
    "product": "appGetGoodsInfor.php",
]

func login(username: String, password: String, completion: (NSDictionary?) -> Void) {
    let query_url = BASE_URL + "appLogin.php" + "?"
    Alamofire.request(
        .GET,
        query_url,
        parameters: ["act": "login", "u":username, "p":password]
    ).validate().responseJSON { (response) in
        print(response.request!.URL!.URLString)
        if let json = response.result.value {
            completion(json as? NSDictionary)
        }
    }
}

func logout(completion: (NSDictionary?) -> Void) {
    let query_url = BASE_URL + "appLogin.php" + "?"
    Alamofire.request(
        .GET,
        query_url,
        parameters: ["act": "logout"]
    ).validate().responseJSON { (response) in
        if let json = response.result.value {
            completion(json as? NSDictionary)
        }
    }
}

func get_json_data(query_type: String, query_paramters: [String: AnyObject], completion: (NSDictionary?) -> Void) {
    let query_url = BASE_URL + query_type_url[query_type]! + "?"
    Alamofire.request(
        .GET,
        query_url,
        parameters: query_paramters
    ).validate().responseJSON { response in
        print(response.request!.URL!.URLString)
        if let json = response.result.value {
            completion(json as? NSDictionary)
        }
    }
}
// Given name of the selected item in each search category, find the corresponding ID to use in the GET request.
func find_id_from_name(name: String) -> String {
    if (name == "-") {
        return ""
    }
    let results = id_reference_list.filter({
        $0["name"] as? String == name
    })
    if let id_string = results[0]["id"] as? Int {
        return String(id_string)
    } else {
        return ""
    }
}