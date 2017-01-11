//
//  Model.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import Foundation


struct User {
    static var user_rank: Int = -1
    static var username: String = ""
    static var company_name: String = ""
    static var shopping_count = -1

    init(name: String, rank: Int, company: String, shopping: Int) {
        User.user_rank = rank
        User.username = name
        User.company_name = company
        User.shopping_count = shopping
    }
}
