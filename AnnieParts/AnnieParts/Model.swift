//
//  Model.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import Foundation

class User {
    private var _user_rank: Int
    private var _username: String
    private var _company_name: String
    private var _shopping_cart_count: Int

    var username: String {
        return _username
    }
    var user_rank: Int {
        return _user_rank
    }
    var company_name: String {
        return _company_name
    }
    var shopping_cart_count: Int {
        return _shopping_cart_count
    }

    init(username: String, user_rank: Int, company_name: String, shopping_cart: Int) {
        _username = username
        _user_rank = user_rank
        _company_name = company_name
        _shopping_cart_count = shopping_cart
    }
    init() {
        _username = ""
        _user_rank = -1
        _company_name = ""
        _shopping_cart_count = -1
    }
}
