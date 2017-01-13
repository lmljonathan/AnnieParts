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

struct Search {
    var search_options: [Option]
    struct Option {
        var expanded: Bool
        var options: [String]
        var option_ids: [Int]

        init(option_array: [String], option_ids_array: [Int]) {
            expanded = false
            options = option_array
            option_ids = option_ids_array
        }
        init() {
            expanded = false
            options = []
            option_ids = []
        }
    }
    init(option1: Option, option2: Option, option3: Option) {
        search_options = [option1, option2, option3]
    }
    init() {
        search_options = []
    }
}
