//
//  AddProductPopupViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/18/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import PopupController

class AddProductPopupViewController: UIViewController, PopupContentViewController {

    private var popupSize: CGSize!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSizeMake(200,200)
        self.popupSize = CGSizeMake(200,200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instance() -> AddProductPopupViewController {
        return (UIStoryboard(name: "AddProductPopup", bundle: nil).instantiateInitialViewController() as! AddProductPopupViewController)
    }
    
    // PopupContentViewController Protocol
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return popupSize
    }
}
