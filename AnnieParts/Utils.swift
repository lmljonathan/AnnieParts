//
//  utils.swift
//  Leap
//
//  Created by Jonathan Lam on 9/9/15.
//  Copyright (c) 2015 Limitless Studios. All rights reserved.
//

import Foundation

var GlobalMainQueue: DispatchQueue {
    return .main
}

var GlobalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: .default)
}

var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInitiated)

}

var GlobalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: .utility)
}

var GlobalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: .background)
}
