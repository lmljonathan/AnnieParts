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
let PRODUCTS_URL = "appSearch.php"

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

func configureIDS(completion: @escaping() -> Void) {
    let query_url = BASE_URL + SEARCH_OPTIONS_URL
    Alamofire.request(query_url, method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
        if let data = response.result.value as? [String:Any] {
            if check_status(response: data) {
                if let attributes = data["attributes"] as? [[String:Any]] {
                    (CONSTANTS.IDS.ATTRIBUTES, CONSTANTS.IDS.ATTRIBUTE_IDS) = extract_options(data: attributes)
                }
                if let pinpai = data["pinpai"] as? [[String:Any]] {
                    (CONSTANTS.IDS.PINPAI, CONSTANTS.IDS.PINPAI_IDS) = extract_options(data: pinpai)
                }
                if let manufacturers = data["manufactures"] as? [[String:Any]] {
                    (CONSTANTS.IDS.MANUFACTURERS, CONSTANTS.IDS.MANUFACTURER_IDS) = extract_options(data: manufacturers)
                }
                if let models = data["models"] as? [[String:Any]] {
                    (CONSTANTS.IDS.MODELS, CONSTANTS.IDS.MODEL_IDS) = extract_options(data: models)
                }
                completion()
            }
        }
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
                    option1 = extract_options(data: models, category: "车型")
                }
                if let pinpai = data["pinpai"] as? [[String:Any]] {
                    option2 = extract_options(data: pinpai, category: "品牌")
                }
                if let attributes = data["attributes"] as? [[String:Any]] {
                    option3 = extract_options(data: attributes, category: "产品")
                }
                completion(Search(option1: option1, option2: option2, option3: option3))
            }
        }
    }
}

func product_list_request(search_query: String, completion: @escaping ([Product]) -> Void) {
    let query_url = BASE_URL + PRODUCTS_URL + "?" + search_query
    var product_list: [Product] = []
    Alamofire.request(query_url, method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
        if let data = response.result.value as? [String:Any] {
            if (check_status(response: data)) {
                if let products = data["rlist"] as? [[String:Any]] {
                    for product in products {
                        let id = product["id"] as? Int ?? 0
                        let model_ids = product["model_list"] as? [Int] ?? []
                        let make_id = product["brand_id"] as? Int ?? 0
                        let name = product["name"] as? String ?? ""
                        let serial_number = product["sn"] as? String ?? ""
                        let start_year = product["start_time"] as? Int ?? 0
                        let end_year = product["end_time"] as? Int ?? 0
                        let image = product["img"] as? String ?? ""
                        product_list.append(Product(product_id: id, model_ids: model_ids, make_id: make_id, name: name, serial_number: serial_number, start_year: start_year, end_year: end_year, image: image))
                    }
                    completion(product_list)
                }
            }
        }
    }
}

func extract_options(data: [[String:Any]]) -> ([String], [Int]) {
    var options: [String] = []
    var optionids: [Int] = []
    for dict in data {
        options.append(dict["name"] as? String ?? "")
        optionids.append(dict["id"] as? Int ?? -1)
    }
    return (options, optionids)
}

func extract_options(data: [[String:Any]], category: String) -> Search.Option {
    var options: [String] = []
    var optionids: [Int] = []
    for dict in data {
        options.append(dict["name"] as? String ?? "")
        optionids.append(dict["id"] as? Int ?? -1)
    }
    return Search.Option(option_array: options, option_ids_array: optionids, title: category)
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
