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
    let loading = UIActivityIndicatorView(frame: CGRect(x: view.center.x - 50.0, y: view.center.y - 100.0, width: 100.0, height: 100.0))
    loading.activityIndicatorViewStyle = .gray
    loading.hidesWhenStopped = true

    view.addSubview(loading)
    loading.startAnimating()
    view.bringSubview(toFront: loading)
    return loading
}

func performLogin(vc: UIViewController) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
    vc.present(loginVC, animated: true, completion: nil)
}
