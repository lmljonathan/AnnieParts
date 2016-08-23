//
//  User.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/12/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation

struct User {
    static var userRank = -1
    static var username = ""
    static var companyName = ""
    static func setUserRank(rank: Int) {
        if (rank < 1 || rank > 4) {
            print("this rank does not exist")
        }
        else {
            userRank = rank
        }
    }

    static func getUserStatus() -> String {
        if (userRank != -1) {
            return CONSTANTS.USER_RANKS[userRank]!
        }
        return ""
    }
}