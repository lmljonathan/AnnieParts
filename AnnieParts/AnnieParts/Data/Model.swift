//
//  Model.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import Foundation
import UIKit

class User {
    static let sharedInstance = User()
    var user_rank: Int = -1
    var username: String = ""
    var company_name: String = ""
    var shopping_count = -1

    private init () {}
}


struct Details {
    var detail_options: [Option]
    struct Option {
        var expanded: Bool
        var options: [String]
        var option_paths: [String]
        var category: String

        init(option_array: [String], option_paths_array: [String], title: String) {
            expanded = false
            options = option_array
            option_paths = option_paths_array
            category = title
        }
        init() {
            expanded = false
            options = []
            option_paths = []
            category = ""
        }
    }
    init() {
        detail_options = []
    }
    mutating func addOption(new_option: Option) {
        detail_options.append(new_option)
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
    private var _product_id: Int = -1
    private var _model_ids: [Int] = []
    private var _make_id: Int = -1

    private var _name: String = ""
    private var _serial_number: String = ""
    private var _start_year: String = ""
    private var _end_year: String = ""
    private var _thumb_image_path: String = ""

    private var _price: Double = 0
    private var _brief_description: String = ""
    private var _description: String = ""
    private var _install_file_titles: [String] = []
    private var _install_file_paths: [String] = []
    private var _video_titles: [String] = []
    private var _video_paths: [String] = []
    private var _all_images: [String] = []

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
    var video_titles: [String] {
        return _video_titles
    }
    var video_paths: [String] {
        return _video_paths
    }
    var images: [String] {
        return _all_images
    }
    
    init(product_id: Int, model_ids: [Int], make_id: Int, name: String, serial_number: String, start_year: String, end_year: String, image: String, price: Double, brief: String, description: String, install_titles: [String], install_paths: [String], video_titles: [String], video_paths: [String], all_images: [String]) {
        _product_id = product_id
        _model_ids = model_ids
        _make_id = make_id
        _name = name
        _serial_number = serial_number
        _start_year = start_year
        _end_year = end_year
        _thumb_image_path = image

        _price = price
        _brief_description = brief
        _description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget tellus nec nisi tincidunt dapibus bibendum quis nibh. Nunc diam justo, fermentum et risus nec, consequat scelerisque nisl. Nulla vitae porttitor erat. Nulla dapibus nulla non nibh feugiat fermentum. Praesent vestibulum tortor lectus, eu vestibulum nisi ultricies eget. Aliquam auctor eleifend tincidunt. Nulla nisi augue, blandit eget turpis et, tristique convallis libero. Nulla dictum condimentum laoreet."
        _all_images = all_images
        _install_file_titles = install_titles
        _install_file_paths = install_paths
        _video_titles = video_titles
        _video_paths = video_paths
        _all_images = all_images
    }

    func decodeString(encodedString:String) -> NSAttributedString?
    {
        let encodedData = encodedString.data(using: .utf8)
        do {
            return try NSAttributedString(data: encodedData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    func printProduct()
    {
        print("Product id: \(_product_id)")
        print("Model ids: \(_model_ids)")
        print("Make id: \(_make_id)")
        print("install_file_titles: \(_install_file_titles)")
        print("install_file_paths: \(_install_file_paths)")
        print("video paths: \(_video_paths)")
        print("all images: \(_all_images)")
    }
}

class ShoppingProduct
{
    private var _product_id: Int = -1
    private var _model_ids: [Int] = []
    private var _make_id: Int = -1

    private var _name: String = ""
    private var _serial_number: String = ""
    private var _start_year: String = ""
    private var _end_year: String = ""
    private var _thumb_image_path: String = ""

    private var _price: Double = 0
    private var _quantity: Int = 0

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
    var quantity: Int {
        return _quantity
    }

    init(product_id: Int, model_ids: [Int], make_id: Int, name: String, serial: String,  start_year: String, end_year: String, image: String, price: Double, quantity: Int)
    {
        _product_id = product_id
        _model_ids = model_ids
        _name = name
        _serial_number = serial
        _start_year = start_year
        _end_year = end_year
        _thumb_image_path = image
        _price = price
        _quantity = quantity
    }
}
