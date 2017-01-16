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
        var category: String

        init(option_array: [String], option_ids_array: [Int], title: String) {
            expanded = false
            options = option_array
            option_ids = option_ids_array
            category = title
        }
        init() {
            expanded = false
            options = []
            option_ids = []
            category = ""
        }
    }
    init(option1: Option, option2: Option, option3: Option) {
        search_options = [option1, option2, option3]
    }
    init() {
        search_options = []
    }
}

class Product {
    private var _product_id: Int
    private var _model_ids: [Int]
    private var _make_id: Int

    private var _name: String
    private var _serial_number: String
    private var _make: String
    private var _models: [String]
    private var _start_year: Int
    private var _end_year: Int
    private var _image_path: String

    var name: String {
        return _name
    }
    var serial_number: String {
        return _serial_number
    }
    var image_path: String {
        return _image_path
    }
    init(product_id: Int, model_ids: [Int], make_id: Int, name: String, serial_number: String, start_year: Int, end_year: Int, image: String) {
        _product_id = product_id
        _model_ids = model_ids
        _make_id = make_id
        _name = name
        _serial_number = serial_number
        _make = ""
        _start_year = start_year
        _end_year = end_year
        _image_path = image
        _models = ["", "", ""]
    }
}
