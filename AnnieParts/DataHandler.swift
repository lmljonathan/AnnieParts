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


func login(username: String, password: String, completion: (NSDictionary?) -> Void) {
    let query_url = CONSTANTS.URL_INFO.BASE_URL + CONSTANTS.URL_INFO.LOGIN_URL + "?"
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
    let query_url = CONSTANTS.URL_INFO.BASE_URL + CONSTANTS.URL_INFO.LOGOUT_URL + "?"
    Alamofire.request(
        .GET,
        query_url,
        parameters: CONSTANTS.URL_INFO.LOGOUT_ACTION
    ).validate()
}
func send_request(query_type: String, query_paramters: [String: AnyObject]) {
    let query_url = CONSTANTS.URL_INFO.BASE_URL + query_type + "?"
    Alamofire.request(
        .GET,
        query_url,
        parameters: query_paramters
    ).validate()
}
func get_json_data(query_type: String, query_paramters: [String: AnyObject], completion: (NSDictionary?) -> Void) {
    let query_url = CONSTANTS.URL_INFO.BASE_URL + query_type + "?"
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