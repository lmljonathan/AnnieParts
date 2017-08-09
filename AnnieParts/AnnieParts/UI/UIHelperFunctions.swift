//
//  UIHelperFunctions.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/13/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import Foundation
import UIKit
import Presentr

var loading_presenter: Presentr {
    let presenter = Presentr(presentationType: .fullScreen)
    presenter.dismissOnSwipe = false
    presenter.dismissOnTap = false
    presenter.transitionType = .crossDissolve
    presenter.dismissTransitionType = .crossDissolve
    presenter.blurBackground = false
    return presenter
}

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

func configureTabBar(tab: UITabBarController) {
    var viewControllers = tab.viewControllers
    if (User.sharedInstance.user_rank <= 1) {
        viewControllers?.remove(at: 2)
        tab.viewControllers = viewControllers
        User.sharedInstance.cart_position = 2
    }
    else {
        User.sharedInstance.cart_position = 3
    }

    tab.setViewControllers(viewControllers, animated: false)

    if (User.sharedInstance.shopping_count <= 0) {
        tab.tabBar.items![User.sharedInstance.cart_position].badgeValue = nil
    }
    else {
        tab.tabBar.items![User.sharedInstance.cart_position].badgeValue = "\(User.sharedInstance.shopping_count)"
    }
}

func updateCartBadge(tab: UITabBarController, increase: Int) {
    User.sharedInstance.shopping_count += increase
    tab.tabBar.items![User.sharedInstance.cart_position].badgeValue = "\(User.sharedInstance.shopping_count)"
}

func updateCartBadge(tab: UITabBarController, total: Int) {
    User.sharedInstance.shopping_count = total
    if (total == 0) {
        tab.tabBar.items![User.sharedInstance.cart_position].badgeValue = nil
    }
    else {
        tab.tabBar.items![User.sharedInstance.cart_position].badgeValue = "\(User.sharedInstance.shopping_count)"
    }
}

class RoundedButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
}

class GradientRoundedButton: RoundedButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func applyGradient(colors: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradient, at: 0)
    }
}

class RedGradientRoundedButton: GradientRoundedButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.maroon(), for: .highlighted)
        self.setBackgroundImage(UIImage(named: "deletebutton_normal"), for: .normal)
        self.setBackgroundImage(UIImage(named: "deletebutton_normal"), for: .selected)
        self.setBackgroundImage(UIImage(named: "deletebutton_pressed"), for: .highlighted)
    }
}

class WhiteGradientRoundedButton: GradientRoundedButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(UIColor.darkText, for: .normal)
        self.setTitleColor(UIColor.darkGray, for: .highlighted)
        self.setBackgroundImage(UIImage(named: "whitebutton_normal"), for: .normal)
        self.setBackgroundImage(UIImage(named: "whitebutton_normal"), for: .selected)
        self.setBackgroundImage(UIImage(named: "whitebutton_pressed"), for: .highlighted)
    }
}
