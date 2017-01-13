//
//  DataHandler.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import Foundation
import Alamofire

let BASE_URL = "http://www.annieparts.com/"
let LOGIN_URL = "appLogin.php"
let SEARCH_OPTIONS_URL = "appGetCfg.php"

func login_request(username: String, password: String, completion: @escaping (Bool) -> Void) {
    let query_url = BASE_URL + LOGIN_URL + "?"
    Alamofire.request(query_url, method: .get, parameters: ["act": "login", "u": username, "p": password], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if let data = response.result.value as? [String: Any] {
            if check_status(response: data) {
                let username = data["uname"] as! String
                let user_rank = data["user_rank"] as! Int
                let company = data["cname"] as! String
                let shopping_count = data["shopping_cnt"] as! Int
                User(name: username, rank: user_rank, company: company, shopping: shopping_count)
                completion(true)
                return
            }
        }
        completion(false)
    }
}

func search_options_request(completion: @escaping (Search) -> Void) {
    let query_url = BASE_URL + SEARCH_OPTIONS_URL
    var option1: Search.Option = Search.Option()
    var option2: Search.Option = Search.Option()
    var option3: Search.Option = Search.Option()
    Alamofire.request(query_url, method: .get, parameters: [:], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if let data = response.result.value as? [String:Any] {
            if (check_status(response: data)) {
                if let models = data["models"] as? [[String:Any]] {
                    option1 = extract_options(data: models)
                }
                if let pinpai = data["pinpai"] as? [[String:Any]] {
                    option2 = extract_options(data: pinpai)
                }
                if let attributes = data["attributes"] as? [[String:Any]] {
                    option3 = extract_options(data: attributes)
                }
                completion(Search(option1: option1, option2: option2, option3: option3))
            }
        }
    }
}

func extract_options(data: [[String:Any]]) -> Search.Option {
    var options: [String] = []
    var optionids: [Int] = []
    for dict in data {
        options.append(dict["name"] as? String ?? "")
        optionids.append(dict["id"] as? Int ?? -1)
    }
    return Search.Option(option_array: options, option_ids_array: optionids)
}

func check_status(response: [String:Any]) -> Bool {
    if let status = response["status"] as? Int {
        if (status == 1) {
            print("HTTP OK")
            return true
        }
    }
    return false
}
