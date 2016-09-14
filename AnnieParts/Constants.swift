//
//  Constants.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/14/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation

struct CONSTANTS {
    static let USER_RANKS = [1: "浏览者", 2:"经销商（铜）", 3: "经销商（银）", 4: "经销商（金）"]
    static let SEARCH_OPTIONS = ["model", "pinpai", "attr"]
    static let ADD_TO_CART_LABEL = "加入购物车"
    static let UPDATE_CART_LABEL = "更改"
    static let ADDED_TO_CART_LABEL = "加入成功"
    static let UPDATED_QUANTITY_LABEL = "更改成功"
    static let SIDE_MENU_OPTIONS = ["搜索", "购物车", "Orders"] // Change
    struct URL_INFO {
        static let BASE_URL = "http://www.annieparts.com/"
        static let CONFIG = "appGetCfg.php"
        static let OPTION_SEARCH = "appSearch.php"
        static let KEYWORD_SEARCH = "appSearchKeyword.php"
        static let PRODUCT_DETAIL = "appGetGoodsInfo.php"
        static let SHOPPING_CART = "appGetShoppingCart.php"
        static let ADD_TO_CART = "appAddGoods2Cart.php"
        static let DELETE_FROM_CART = "appDeleteFromCart.php"
        static let LOGIN_URL = "appLogin.php"
        static let LOGOUT_URL = "appLogout.php"
        static let LOGOUT_ACTION = ["act": "logout"]
        static let CHECKOUT = "appFinishShopping.php"
        static let ORDER_LIST = "appGetOrderList.php"
        static let ORDER_DETAIL = "appGetOrderInfo.php?order_id="
        static let CONFIRM_BUSINESS_ORDER = "appConfirmBorder.php"
    }
    struct VC_IDS {
        static let LOGIN_LOADING = "loadingVC"
        static let ADD_PRODUCT_POPUP = "popup"
        static let ORDER_SUMMARY_MODAL = "orderSummary"
        static let ORDER_CONFIRM_MODAL = "confirmVC"
    }
    struct SEGUES {
        static let TO_SEARCH_OPTIONS = "pushToSearch"
        static let SHOW_SEARCH_RESULTS = "showResults"
        static let SHOW_PRODUCT_DETAIL = "showDetail"
        static let SHOW_CENTER = "showCenterSearch"
        static let SIDE_MENU = "containSideMenu"
        static let SHOPPING_CART = "showCenterShoppingCart"
        static let ORDERS = "showCenterOrders"
        static let LOGIN = "showCenterLogin"
        static let IMAGE_ZOOM = "zoomImage"
    }
    struct JSON_KEYS {
        static let API_STATUS = "status"
        static let USER_RANK = "user_rank"
        static let USERNAME = "uname"
        static let COMPANY_NAME = "cname"
        static let PRODUCT_MANUFACTURER = "pinpai"
        static let PRODUCT_TYPES = "attributes"
        static let YEAR_LIST = "years"
        static let MANUFACTURERS_LIST = "manufactures"
        static let MODEL_LIST = "models"
        static let ID = "id"
        static let MODEL_ID = "model_id"
        static let MODEL_ID_LIST = "model_list"
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
        static let PRICE = "goods_price"
        static let SERIAL_NUMBER = "sn"
        
        static let MAKE_ID = "brand_id"
        static let PRODUCT_QUANTITY = "goods_number"
        static let GOODS_ID = "goods_id"
        static let ACTION = "act"
        
        // Orders
        static let CUSTOMER_ORDER_LIST = "customerOrder"
        static let UNPROCESSED_ORDER_LIST = "unprocessedOrder"
        static let PROCESSED_ORDER_LIST = "processedOrder"
        
        static let ADD_TIME = "add_time"
        static let USER_ID = "user_id"
        static let ORDER_ID = "order_id"
        static let ORDER_SN = "order_sn"
        static let TOTAL_PRICE = "goods_amount"
        static let STATUS = "status"
        
    
    }
    struct CELL_IDENTIFIERS {
        static let SEARCH_OPTIONS_CELLS = "selectCell"
        static let SEARCH_RESULTS_CELLS = "searchResultsCell"
        static let SHOPPING_CART_CELLS = "shoppingCartCell"
        static let SIDE_MENU_CELLS = "menuCell"
        static let NO_RESULTS_FOUND_CELL = "noItemsCell"
        static let ORDER_SUMMARY_CELL = "summaryCell"
        static let ORDER_CELL = "orderCell"
    }
    struct IMAGES {
        static let BACK_BUTTON = "back"
        static let SEARCH_ICON = "search"
        static let CART_ICON = "cart"
        static let ORDERS_ICON = "orders"
    }
}