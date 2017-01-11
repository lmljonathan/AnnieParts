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

func login_request(username: String, password: String, completion: @escaping (User, Bool) -> Void) {
    let query_url = BASE_URL + LOGIN_URL + "?"
    Alamofire.request(query_url, method: .get, parameters: ["act": "login", "u": username, "p": password], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if let data = response.result.value as? [String: Any] {
            if let status = data["status"] as? Int {
                if (status == 1) {
                    let username = data["uname"] as! String
                    let user_rank = data["user_rank"] as! Int
                    let company = data["cname"] as! String
                    let shopping_count = data["shopping_cnt"] as! Int
                    completion(User(username: username, user_rank: user_rank, company_name: company, shopping_cart: shopping_count), true)
                }
            }
        }
        completion(User(),false)
    }
}
