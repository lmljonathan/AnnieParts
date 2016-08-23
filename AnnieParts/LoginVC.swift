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
    @IBOutlet weak var loginLayer: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPassButton: UIButton!
    
    // MARK: - View Loading Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        anniepartsText.frame.size.width = self.view.frame.size.width * 6/7
        anniepartsText.adjustsFontSizeToFitWidth = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
        self.loginLayer.layer.borderWidth = 1.0
        self.loginLayer.layer.borderColor = UIColor.whiteColor().CGColor
        self.navigationController?.navigationBarHidden = true
        self.username.delegate = self
        self.password.delegate = self
    }
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
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
        self.loginButton.enabled = false
        if (!self.username.text!.isEmpty && !self.password.text!.isEmpty) {

            self.showLoadingView("Logging In", bgColor: .whiteColor(), completion: { (loadingVC) in
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
                        }
                        else {}
                    }
                    loadingVC.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        }
        else {
            print("username or password field empty")
        }
        self.loginButton.enabled = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        self.resignFirstResponder()
        if view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectedTextRange = textField.textRangeFromPosition(textField.beginningOfDocument, toPosition: textField.endOfDocument)
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

