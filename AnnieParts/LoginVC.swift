//
//  ViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/15/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - IB Outlets
    
    @IBOutlet var anniepartsText: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPassButton: UIButton!
    
    // MARK: - View Loading Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        anniepartsText.frame.size.width = self.view.frame.size.width * 6/7
        anniepartsText.adjustsFontSizeToFitWidth = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
        self.navigationController?.navigationBarHidden = true
        self.username.delegate = self
        self.password.delegate = self
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if (self.view.frame.height - self.loginButton.frame.origin.y < keyboardSize.height + 10) {
                if view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if (self.view.frame.height - self.loginButton.frame.origin.y < keyboardSize.height + 10) {
                if view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
        }
    }
    // MARK: - IB Outlet Actions
    
    @IBAction func loginPressed(sender: UIButton) {
        performLogin()
    }
    
    @IBAction func forgetPasswordPressed(sender: UIButton) {
        
    }
    
    // MARK: - Main Functions
    
    func performLogin(){
        self.loginButton.userInteractionEnabled = false
        if (!self.username.text!.isEmpty && !self.password.text!.isEmpty) {
            login(self.username.text!, password: self.password.text!, completion: { (json) in
                if let status = json![CONSTANTS.JSON_KEYS.API_STATUS] as? Int {
                    if status == 1 {
                        if let rank = json![CONSTANTS.JSON_KEYS.USER_RANK] as? Int {
                            User.setUserRank(rank)
                        }
                        if let username = json![CONSTANTS.JSON_KEYS.USERNAME] as? String {
                            User.username = username
                        }
                        if let companyname = json![CONSTANTS.JSON_KEYS.COMPANY_NAME] as? String {
                            User.companyName = companyname
                        }
                        self.performSegueWithIdentifier(CONSTANTS.SEGUES.TO_SEARCH_OPTIONS, sender: self)
                    } else {
                        self.incorrectPassword()
                        self.loginButton.userInteractionEnabled = true
                    }
                }
            })
        }
        else {
            print("username or password field empty")
            incorrectPassword()
            self.loginButton.userInteractionEnabled = true
            self.loginButton.highlighted = false
        }
    }
    func incorrectPassword() {
        self.username.layer.shake()
        self.password.layer.shake()
        self.username.text = ""
        self.password.text = ""
        self.username.becomeFirstResponder()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        self.resignFirstResponder()
        if view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == username{
            if textField.text != ""{
                password.becomeFirstResponder()
            }
            textField.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
            performLogin()
        }
        return true
    }
    
    
}

