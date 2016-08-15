//
//  Constants.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/14/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation

struct CONSTANTS {
    static let USER_RANKS = [1: "browser", 2:"dealer(bronze)", 3: "dealer(silver)", 4: "dealer(gold)"]
    static let SEARCH_OPTIONS = [["BRAND"], ["YEAR", "MAKE", "MODEL"], ["PRODUCT TYPE"]]
    static let SEARCH_OPTION_VIEWS = ["searchByBrand:", "searchByCar:", "searchByProduct:"]
    static let ADD_TO_CART_LABEL = "Add to Cart"
    static let UPDATE_CART_LABEL = "Update"
    static let SIDE_MENU_OPTIONS = ["Search", "Shopping Cart"]
    struct URL_INFO {
        static let BASE_URL = "http://www.annieparts.com/"
        static let CONFIG = "appGetCfg.php"
        static let OPTION_SEARCH = "appSearch.php"
        static let KEYWORD_SEARCH = "appSearchKeyword.php"
        static let PRODUCT_DETAIL = "appGetGoodsInfor.php"
        static let SHOPPING_CART = "appGetShoppingCart.php"
        static let ADD_TO_CART = "appAddGoods2Cart.php"
        static let DELETE_FROM_CART = "appDeleteFromCart.php"
        static let LOGIN_URL = "appLogin.php"
        static let LOGOUT_URL = "appLogout.php"
        static let LOGOUT_ACTION = ["act": "logout"]
    }
    struct VC_IDS {
        static let LOGIN_LOADING = "loadingVC"
        static let ADD_PRODUCT_POPUP = "popup"
    }
    struct SEGUES {
        static let TO_SEARCH_OPTIONS = "pushToSearch"
        static let SHOW_SEARCH_RESULTS = "showResults"
        static let SHOW_PRODUCT_DETAIL = "showDetail"
        static let SHOW_CENTER = "showCenterSearch"
        static let SIDE_MENU = "containSideMenu"
        static let SHOPPING_CART = "showCenterShoppingCart"
        static let LOGIN = "showCenterLogin"
    }
    struct JSON_KEYS {
        static let API_STATUS = "status"
        static let USER_RANK = "user_rank"
        static let PRODUCT_MANUFACTURER = "pinpai"
        static let PRODUCT_TYPES = "attributes"
        static let YEAR_LIST = "years"
        static let MANUFACTURERS_LIST = "manufactures"
        static let MODEL_LIST = "models"
        static let ID = "id"
        static let NAME = "name"
        static let PARENT_ID = "pid"
        static let YEAR = "year"
        static let MAKE = "brand"
        static let MODEL = "model"
        static let PRODUCT_TYPE = "attr"
        static let SEARCH_RESULTS_LIST = "rlist"
        static let IMAGE = "img"
        static let START_YEAR = "start_time"
        static let END_YEAR = "end_time"
        static let QUANTITY = "cnt"
        
        static let PRODUCT_ID = "goods_id"
        static let MAKE_ID = "brand_id"
        static let PRODUCT_NAME = "goods_name"
        static let PRODUCT_QUANTITY = "goods_number"
        
        static let ACTION = "act"
    }
    struct CELL_IDENTIFIERS {
        static let SEARCH_OPTIONS_CELLS = "selectCell"
        static let SEARCH_RESULTS_CELLS = "searchResultsCell"
        static let SHOPPING_CART_CELLS = "shoppingCartCell"
        static let SIDE_MENU_CELLS = "menuCell"
    }
    struct IMAGES {
        static let BACK_BUTTON = "back"
        static let SEARCH_ICON = "search"
        static let CART_ICON = "cart"
    }
}