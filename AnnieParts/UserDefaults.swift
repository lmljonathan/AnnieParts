//
//  UserDefaults.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/27/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let username = DefaultsKey<String>("username")
    static let password = DefaultsKey<String>("password")
    static let automaticLogin = DefaultsKey<Bool>("autoLogin")
}