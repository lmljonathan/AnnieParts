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
    private var _thumb_image_path: String

    private var _price: Double
    private var _brief_description: String
    private var _description: String
    private var _install_file_titles: [String]
    private var _install_file_paths: [String]
    private var _video_paths: [String]
    private var _all_images: [String]

    var product_id: Int {
        return _product_id
    }
    var name: String {
        return _name
    }
    var serial_number: String {
        return _serial_number
    }
    var thumb_image_path: String {
        return _thumb_image_path
    }
    var make: String {
        if let index = CONSTANTS.IDS.MANUFACTURER_IDS.index(of: _make_id) as Int! {
            return CONSTANTS.IDS.MANUFACTURERS[index]
        }
        return ""
    }
    var years: String {
        return String(_start_year) + " - " + String(_end_year)
    }
    var models: String {
        var model_string = ""
        for id in _model_ids {
            if let index = CONSTANTS.IDS.MODEL_IDS.index(of: id) as Int! {
                model_string += CONSTANTS.IDS.MODELS[index] + ", "
            }
        }
        return model_string
    }
    var price: Double {
        return _price
    }
    var brief_description: String {
        return _brief_description
    }
    var description: String {
        return _description
    }
    var install_titles: [String] {
        return _install_file_titles
    }
    var install_paths: [String] {
        return _install_file_paths
    }
    var video_paths: [String] {
        return _video_paths
    }
    var images: [String] {
        return _all_images
    }

    func initializeDetails(price: Double, brief: String, description: String, installs: [[String:String]], videos: [String], all_images: [String]) {
        _price = price
        _brief_description = brief
        _description = description
        _video_paths = videos
        _all_images = all_images
        for install in installs {
            _install_file_titles.append(install["title"] ?? "")
            _install_file_paths.append(install["href"] ?? "")
        }
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
        _thumb_image_path = image
        _models = ["", "", ""]

        _price = -1.0
        _brief_description = ""
        _description = ""
        _install_file_titles = []
        _install_file_paths = []
        _video_paths = []
        _all_images = []
    }

    init() {
        _product_id = -1
        _model_ids = []
        _make_id = -1
        _name = ""
        _serial_number = ""
        _make = ""
        _start_year = -1
        _end_year = -1
        _thumb_image_path = ""
        _models = []

        _price = -1.0
        _brief_description = ""
        _description = ""
        _install_file_titles = []
        _install_file_paths = []
        _video_paths = []
        _all_images = []
    }
}
