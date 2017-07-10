//
//  DataHandler.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let BASE_URL = "http://www.annieparts.com/"
let LOGIN_URL = "appLogin.php"
let SEARCH_OPTIONS_URL = "appGetCfg.php"
let PRODUCTS_URL = "bppSearch.php"

func login_request(username: String, password: String, completion: @escaping (Bool) -> Void) {
    let query_url = BASE_URL + LOGIN_URL + "?"
    Alamofire.request(query_url, method: .get, parameters: ["act": "login", "u": username, "p": password], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil) {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1)
            {
                User(
                    name: json["uname"].stringValue,
                    rank: json["user_rank"].intValue,
                    company: json["cname"].stringValue,
                    shopping: json["shopping_cnt"].intValue
                )
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
                    option1 = extract_options(data: models, category: "model")
                }
                if let pinpai = data["pinpai"] as? [[String:Any]] {
                    option2 = extract_options(data: pinpai, category: "pinpai")
                }
                if let attributes = data["attributes"] as? [[String:Any]] {
                    option3 = extract_options(data: attributes, category: "attr")
                }
                completion(Search(option1: option1, option2: option2, option3: option3))
            }
        }
    }
}

func product_list_request(search_query: String, completion: @escaping ([Product]) -> Void) {
    let query_url = BASE_URL + PRODUCTS_URL + "?" + search_query
    var product_list: [Product] = []
    print(query_url)
    Alamofire.request(query_url, method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1) {
                let products = json["rlist"].arrayValue
                for product in products {
                    let id = product["id"].intValue
                    let model_ids = product["model_list"].arrayValue.map{$0.intValue}
                    let make_id = product["brand_id"].intValue
                    let name = product["name"].stringValue
                    let serial_number = product["sn"].stringValue
                    let start_year = product["start_time"].stringValue
                    let end_year = product["end_time"].stringValue
                    let image = product["img"].stringValue
                    let price = product["shop_price"].doubleValue
                    let brief_description = product["brief"].stringValue
                    let description = product["desc"].stringValue
                    let install_titles = product["ins"].arrayValue.map{$0["title"].stringValue}
                    let install_paths = product["ins"].arrayValue.map{$0["href"].stringValue}
                    let videos = product["video"].arrayValue.map{$0.stringValue}
                    let image_paths = product["thumb_url"].arrayValue.map{$0.stringValue}

                    product_list.append(
                        Product(
                            product_id: id,
                            model_ids: model_ids,
                            make_id: make_id,
                            name: name,
                            serial_number: serial_number,
                            start_year: start_year,
                            end_year: end_year,
                            image: image,
                            price: price,
                            brief: brief_description,
                            description: description,
                            install_titles: install_titles,
                            install_paths: install_paths,
                            videos: videos,
                            all_images: image_paths
                        )
                    )
                }
                completion(product_list)
            }
            completion([])
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
            return true
        }
    }
    return false
}
