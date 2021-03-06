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
let LOGOUT_URL = "appLogin.php"
let SEARCH_OPTIONS_URL = "appGetCfg.php"
let NEW_PRODUCTS_URL = "appGetNewProducts.php"
let PRODUCT_LIST_URL = "bppSearch.php"
let PRODUCT_ID_SEARCH_URL = "appGetGoodsInfo.php"
let DELETE_FROM_CART_URL = "appDeleteFromCart.php"
let ADD_TO_CART_URL = "appAddGoods2Cart.php"
let UPDATE_CART_URL = "appAddGoods2Cart.php"
let SHOPPING_URL = "appGetShoppingCart.php"
let CHECKOUT_URL = "appFinishShopping.php"
let ORDERS_URL = "appGetOrderList.php"
let ORDER_INFO_URL = "appGetOrderInfo.php"
let CONFIRM_ORDER_URL = "appConfirmBorder.php"
let CANCEL_ORDER_URL = "appCancelOrder.php"

struct RequestHandler {
    static var cart_refresh: Bool = true
}

func login_request(username: String, password: String, completion: @escaping (Bool) -> Void) {
    let query_url = BASE_URL + LOGIN_URL
    print(query_url)

    Alamofire.request(query_url, method: .get, parameters: ["act": "login", "u": username, "p": password], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1)
            {
                let user = User.sharedInstance
                user.username = json["uname"].stringValue
                user.user_rank = json["user_rank"].intValue
                user.company_name = json["cname"].stringValue
                user.shopping_count = json["shopping_cnt"].intValue

                let defaults = UserDefaults.standard
                defaults.set(user.username, forKey: "username")
                defaults.set(user.user_rank, forKey: "user_rank")
                defaults.set(user.company_name, forKey: "company")
                defaults.set(user.shopping_count, forKey: "shopping_count")

                completion(true)
                return
            }
        }
        completion(false)
    }
}

func logout_request(completion: @escaping(Bool) -> Void) {
    let query_url = BASE_URL + LOGOUT_URL
    print(query_url)

    Alamofire.request(query_url, method: .get, parameters: ["act":"logout"], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil) {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1) {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
}

func configureIDS(completion: @escaping(Bool) -> Void) {
    let query_url = BASE_URL + SEARCH_OPTIONS_URL
    print(query_url)

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
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
}

func search_options_request(completion: @escaping (Search) -> Void) {
    let query_url = BASE_URL + SEARCH_OPTIONS_URL
    var option1: Search.Option = Search.Option()
    var option2: Search.Option = Search.Option()
    var option3: Search.Option = Search.Option()

    print(query_url)

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

func new_products_request(completion: @escaping (Bool, [Product]) -> Void) {
    let query_url = BASE_URL + NEW_PRODUCTS_URL
    print(query_url)

    var product_list: [Product] = []
    var success = false

    Alamofire.request(query_url, method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1)
            {
                success = true
                let products = json["rlist"].arrayValue
                for product in products
                {
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
                    let video_titles = product["video"].arrayValue.map{$0["title"].stringValue}
                    let video_paths = product["video"].arrayValue.map{$0["href"].stringValue}
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
                            video_titles: video_titles,
                            video_paths: video_paths,
                            all_images: image_paths
                        )
                    )
                }
            }
            completion(success, product_list)
        }
    }
}

func product_list_request(search_query: String, completion: @escaping (Bool, [Product]) -> Void) {
    let query_url = BASE_URL + PRODUCT_LIST_URL + "?" + search_query
    print(query_url)

    var product_list: [Product] = []
    var success = false

    Alamofire.request(query_url, method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1)
            {
                success = true
                let products = json["rlist"].arrayValue
                for product in products
                {
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
                    let video_titles = product["video"].arrayValue.map{$0["title"].stringValue}
                    let video_paths = product["video"].arrayValue.map{$0["href"].stringValue}
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
                            video_titles: video_titles,
                            video_paths: video_paths,
                            all_images: image_paths
                        )
                    )
                }
            }
            completion(success, product_list)
        }
    }
}

func product_id_search_request(product_id: Int, completion: @escaping(Bool, Product) -> Void) {
    let query_url = BASE_URL + PRODUCT_ID_SEARCH_URL
    print(query_url)

    var product: Product = Product()
    var success: Bool = false

    Alamofire.request(query_url, method: .get, parameters: ["goods_id":product_id], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil) {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1) {
                success = true

                let id = json["id"].intValue
                let model_ids = json["model_list"].arrayValue.map{$0.intValue}
                let make_id = json["brand_id"].intValue
                let name = json["name"].stringValue
                let serial_number = json["sn"].stringValue
                let start_year = json["start_time"].stringValue
                let end_year = json["end_time"].stringValue
                let image = json["img"].stringValue
                let price = json["shop_price"].doubleValue
                let brief_description = json["brief"].stringValue
                let description = json["desc"].stringValue
                let install_titles = json["ins"].arrayValue.map{$0["title"].stringValue}
                let install_paths = json["ins"].arrayValue.map{$0["href"].stringValue}
                let video_titles = json["video"].arrayValue.map{$0["title"].stringValue}
                let video_paths = json["video"].arrayValue.map{$0["href"].stringValue}
                let image_paths = json["thumb_url"].arrayValue.map{$0.stringValue}

                product = Product(
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
                    video_titles: video_titles,
                    video_paths: video_paths,
                    all_images: image_paths
                )
            }
        }
        completion(success, product)
    }
}

func add_product_to_cart_request(product_id: Int, quantity: Int, completion: @escaping(Bool) -> Void) {
    let query_url = BASE_URL + ADD_TO_CART_URL
    print(query_url)
    Alamofire.request(query_url, method: .get, parameters: ["goods_id": product_id, "cnt": quantity], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil) {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1) {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
}

func update_cart_request(product_id: Int, new_quantity: Int, completion: @escaping(Bool) -> Void) {
    let query_url = BASE_URL + UPDATE_CART_URL
    print(query_url)

    Alamofire.request(query_url, method: .get, parameters: ["goods_id": product_id, "cnt": new_quantity, "act":"set"], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1) {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
}



func delete_product_from_cart_request(product_id: Int, completion: @escaping(Bool) -> Void) {
    let query_url = BASE_URL + DELETE_FROM_CART_URL
    print(query_url)

    Alamofire.request(query_url, method: .get, parameters: ["goods_id": product_id], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data:response.data!)
            if (json["status"].intValue == 1) {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
}

func shopping_cart_request(completion: @escaping (Bool, [ShoppingProduct]) -> Void) {
    let query_url = BASE_URL + SHOPPING_URL
    print(query_url)

    var shopping_product_list: [ShoppingProduct] = []
    var success = false

    Alamofire.request(query_url, method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1)
            {
                success = true
                let products = json["rlist"].arrayValue
                for product in products
                {
                    let id = product["id"].intValue
                    let model_ids = product["model_list"].arrayValue.map{$0.intValue}
                    let make_id = product["brand_id"].intValue
                    let name = product["name"].stringValue
                    let serial_number = product["sn"].stringValue
                    let start_year = product["start_time"].stringValue
                    let end_year = product["end_time"].stringValue
                    let image = product["img"].stringValue
                    let price = product["goods_price"].doubleValue
                    let quantity = product["goods_number"].intValue

                    shopping_product_list.append(
                        ShoppingProduct(
                            product_id: id,
                            model_ids: model_ids,
                            make_id: make_id,
                            name: name,
                            serial: serial_number,
                            start_year: start_year,
                            end_year: end_year,
                            image: image,
                            price: price,
                            quantity: quantity
                        )
                    )
                }
            }
            completion(success, shopping_product_list)
        }
    }
}
func checkout_request(completion: @escaping (Bool, String) -> Void) {
    let query_url = BASE_URL + CHECKOUT_URL
    print(query_url)

    Alamofire.request(query_url, method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1) {
                let order_number = json["sn"].stringValue
                completion(true, order_number)
            }
            else {
                completion(false, "")
            }
        }
    }
}
func order_list_request(completion: @escaping(Bool, [[Order]]) -> Void) {
    let query_url = BASE_URL + ORDERS_URL
    print(query_url)

    var all_orders: [[Order]] = []
    var success = false

    Alamofire.request(query_url, method: .get, encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1)
            {
                success = true
                var orders_array: [Order] = []
                let customer_orders = json["customerOrder"].arrayValue
                for order in customer_orders {
                    let order_id = order["order_id"].intValue
                    let user_id = order["user_id"].intValue
                    let sn = order["order_sn"].stringValue
                    let time = order["add_time"].doubleValue
                    let total = order["goods_amount"].doubleValue
                    let status = ""
                    orders_array.append(
                        Order(
                            order_id: order_id,
                            user_id: user_id,
                            serial_number: sn,
                            time: time,
                            total: total,
                            status: status
                        )
                    )
                }
                all_orders.append(orders_array)
                orders_array.removeAll()

                let unprocessed_orders = json["unprocessedOrder"].arrayValue
                for order in unprocessed_orders {
                    let order_id = order["order_id"].intValue
                    let user_id = order["user_id"].intValue
                    let sn = order["order_sn"].stringValue
                    let time = order["add_time"].doubleValue
                    let total = order["goods_amount"].doubleValue
                    let status = ""
                    orders_array.append(
                        Order(
                            order_id: order_id,
                            user_id: user_id,
                            serial_number: sn,
                            time: time,
                            total: total,
                            status: status
                        )
                    )
                }
                all_orders.append(orders_array)
                orders_array.removeAll()

                let processed_orders = json["processedOrder"].arrayValue
                for order in processed_orders {
                    let order_id = order["order_id"].intValue
                    let user_id = order["user_id"].intValue
                    let sn = order["order_sn"].stringValue
                    let time = order["add_time"].doubleValue
                    let total = order["goods_amount"].doubleValue
                    let status = order["status"].stringValue
                    orders_array.append(
                        Order(
                            order_id: order_id,
                            user_id: user_id,
                            serial_number: sn,
                            time: time,
                            total: total,
                            status: status
                        )
                    )
                }
                all_orders.append(orders_array)
                orders_array.removeAll()

            }
            completion(success, all_orders)
        }
    }
}

func order_info_request(order_id: Int, completion: @escaping(Bool, [OrderItem]) -> Void) {
    let query_url = BASE_URL + ORDER_INFO_URL
    print(query_url)

    var order_products: [OrderItem] = []
    var success = false

    Alamofire.request(query_url, method: .get, parameters: ["order_id":order_id], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil)
        {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1)
            {
                success = true
                let items = json["rlist"].arrayValue
                for item in items {
                    let name = item["goods_name"].stringValue
                    let quantity = item["quantity"].intValue
                    let price = item["unit_price"].doubleValue

                    order_products.append(
                        OrderItem(
                            name: name,
                            quantity: quantity,
                            price: price
                        )
                    )
                }
            }
            completion(success, order_products)
        }
    }
}

func confirm_order_request(order_id: Int, completion: @escaping(Bool) -> Void) {
    let query_url = BASE_URL + CONFIRM_ORDER_URL
    print(query_url)

    Alamofire.request(query_url, method: .get, parameters: ["order_id": order_id], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil) {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1) {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
}

func cancel_order_request(order_id: Int, completion: @escaping(Bool) -> Void) {
    let query_url = BASE_URL + CANCEL_ORDER_URL
    print(query_url)

    Alamofire.request(query_url, method: .get, parameters: ["order_id": order_id], encoding: URLEncoding.default).validate().responseJSON { (response) in
        if (response.data != nil) {
            let json = JSON(data: response.data!)
            if (json["status"].intValue == 1) {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
}

func extract_options(data: [[String:Any]]) -> ([String], [Int])
{
    var options: [String] = []
    var optionids: [Int] = []
    for dict in data
    {
        options.append(dict["name"] as? String ?? "")
        optionids.append(dict["id"] as? Int ?? -1)
    }
    return (options, optionids)
}

func extract_options(data: [[String:Any]], category: String) -> Search.Option
{
    var options: [String] = []
    var optionids: [Int] = []
    for dict in data
    {
        options.append(dict["name"] as? String ?? "")
        optionids.append(dict["id"] as? Int ?? -1)
    }
    return Search.Option(option_array: options, option_ids_array: optionids, title: category)
}

func check_status(response: [String:Any]) -> Bool
{
    if let status = response["status"] as? Int
    {
        if (status == 1)
        {
            return true
        }
    }
    return false
}
