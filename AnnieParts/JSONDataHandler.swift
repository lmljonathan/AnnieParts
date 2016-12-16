//
//  DataHandler.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/28/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import SwiftyJSON
import Alamofire
import SwiftyUserDefaults
import Foundation
import UIKit

func login(username: String, password: String, completion: @escaping (NSDictionary?) -> Void) {
    let query_url = CONSTANTS.URL_INFO.BASE_URL + CONSTANTS.URL_INFO.LOGIN_URL + "?"
    
    Alamofire.request(query_url,
                      method: .get,
                      parameters: ["act": "login", "u": username, "p": password]).validate().responseJSON { (response) in
        print(response.request!.url!.absoluteString)
        print(String(data: response.data!, encoding: String.Encoding.utf8)!)
        if let json = response.result.value {
            checkStatus(json: json as! NSDictionary)
            completion(json as? NSDictionary)
        }
    }
}

func logout() {
    let query_url = CONSTANTS.URL_INFO.BASE_URL + CONSTANTS.URL_INFO.LOGOUT_URL + "?"
    Alamofire.request(query_url,
                      method: .get,
                      parameters: CONSTANTS.URL_INFO.LOGOUT_ACTION
    ).validate()
    Defaults[.automaticLogin] = false
}

func send_request(query_type: String, query_paramters: [String: AnyObject]) {
    let query_url = CONSTANTS.URL_INFO.BASE_URL + query_type + "?"
    Alamofire.request(query_url,
                      method: .get,
                      parameters: query_paramters
        ).validate()
}

func get_json_data(query_type: String, query_paramters: [String: AnyObject], completion: @escaping (NSDictionary?) -> Void) {
    let query_url = CONSTANTS.URL_INFO.BASE_URL + query_type + "?"
    
    
    Alamofire.request(query_url,
                      method: .get,
                      parameters: query_paramters
    ).validate().responseJSON { response in
        print("url: \(response.request?.url?.absoluteString)")
        if let json = response.result.value {
            completion(json as? NSDictionary)
        }else{
            print("Did not recieve JSON response.")
            completion(nil)
        }
    }
}
func checkStatus(json: NSDictionary) {
    if let status = json["status"] as? Int {
        if status == 0  {
            logout()
        }
    }
}
