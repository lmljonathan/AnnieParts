//
//  ViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/15/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginLayer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPassButton: UIButton!
    
    // MARK: - View Loading Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginLayer.layer.borderWidth = 1.0
        self.loginLayer.layer.borderColor = UIColor.whiteColor().CGColor
        self.navigationController?.navigationBarHidden = true
    }
    
    // MARK: - IB Outlet Actions
    
    @IBAction func loginPressed(sender: UIButton) {
        if (!self.username.text!.isEmpty && !self.password.text!.isEmpty) {
            print(self.username.text!)
            print(self.password.text!)
            login(self.username.text!, password: self.password.text!, completion: { (json) in
                if let status = json!["status"] as? Int {
                    if status == 1 {
                        print("login success")
                        self.performSegueWithIdentifier("pushToSearch", sender: self)
                    }
                    else {
                        print("login failed")
                    }
                }
            })
        }
        else {
            print("username or password field empty")
        }
        
    }
    
    @IBAction func forgetPasswordPressed(sender: UIButton) {
        
    }
    
    // MARK: - Main Functions
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

