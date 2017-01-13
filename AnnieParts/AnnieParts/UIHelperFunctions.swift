//
//  UIHelperFunctions.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/13/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import Foundation
import UIKit

func startActivityIndicator(view: UIView) -> UIActivityIndicatorView {
    let loading = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 100.0, height: 100.0))
    loading.center = view.center
    loading.activityIndicatorViewStyle = .gray
    loading.hidesWhenStopped = true
    
    view.addSubview(loading)
    loading.startAnimating()
    view.bringSubview(toFront: loading)
    return loading
}
