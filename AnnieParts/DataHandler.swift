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

private let BASE_URL = "http://www.annieparts.com/"
private let query_type_url = [
    "config": "appGetCfg.php",
    "catalog": "appSearch.php",
    "keyword": "appSearchKeyword.php",
    "product": "appGetGoodsInfor.php",
    "shoppingCart": "appGetShoppingCart.php",
    "addToCart": "appAddGoods2Cart.php",
    "deleteFromCart": "appDeleteFromCart.php",
]

func login(username: String, password: String, completion: (NSDictionary?) -> Void) {
    let query_url = BASE_URL + "appLogin.php" + "?"
    Alamofire.request(
        .GET,
        query_url,
        parameters: ["act": "login", "u": username, "p": password]
    ).validate().responseJSON { (response) in
        print(response.request!.URL!.URLString)
        print(String(data: response.data!, encoding: NSUTF8StringEncoding))
        if let json = response.result.value {
            completion(json as? NSDictionary)
        }
    }
}

func logout() {
    let query_url = BASE_URL + "appLogin.php" + "?"
    Alamofire.request(
        .GET,
        query_url,
        parameters: ["act": "logout"]
    ).validate()
}
func send_request(query_type: String, query_paramters: [String: AnyObject]) {
    let query_url = BASE_URL + query_type_url[query_type]! + "?"
    Alamofire.request(
        .GET,
        query_url,
        parameters: query_paramters
    ).validate()
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