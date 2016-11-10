//
//  ViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/15/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SideMenuController
class LoginVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - IB Outlets
    
    @IBOutlet var anniepartsLogo: UIImageView!
    @IBOutlet var anniepartsText: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPassButton: UIButton!

    private var originalFrames: [UIView: CGFloat]?
    
    // MARK: - View Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        anniepartsText.frame.size.width = self.view.frame.size.width * 6/7
        anniepartsText.adjustsFontSizeToFitWidth = true

        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)

        
        self.navigationController?.isNavigationBarHidden = true
        self.username.delegate = self
        self.password.delegate = self

        if (Defaults[.automaticLogin]) {
            self.loginButton.isUserInteractionEnabled = false
            self.username.isEnabled = false
            self.password.isEnabled = false
            let seconds = 1.0
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = DispatchTime(uptimeNanoseconds: UInt64(delay))

            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.automaticLogin()
            })
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.originalFrames = [self.username: self.username.y, self.password: self.password.y, self.loginButton: self.loginButton.y]
        for y in self.originalFrames!.keys{
            print(self.originalFrames![y]!)
        }

    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.username.y != 50{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                // Hide Logo
                self.anniepartsLogo.isHidden = true
                self.anniepartsText.isHidden = true
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.username.makeTranslation(x: self.username.x, y: 50)
                    self.password.makeTranslation(x: self.password.x, y: self.username.frame.maxY + 10)
                    
                    self.loginButton.makeTranslation(x: self.loginButton.x, y: self.view.height - (keyboardSize.height + 70))
                })
                
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if originalFrames != nil{
            self.anniepartsLogo.isHidden = false
            self.anniepartsText.isHidden = false
            
            for view in originalFrames!.keys{
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform = CGAffineTransform(translationX: 0, y: 0)
                })
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
    func automaticLogin() {
        let username = Defaults[.username]
        let password = Defaults[.password]
        self.username.text = username
        self.password.text = password
        login(username: username, password: password, completion: { (json) in
            if let status = json![CONSTANTS.JSON_KEYS.API_STATUS] as? Int {
                if status == 1 {
                    if let rank = json![CONSTANTS.JSON_KEYS.USER_RANK] as? Int {
                        User.setUserRank(rank: rank)
                    }
                    if let username = json![CONSTANTS.JSON_KEYS.USERNAME] as? String {
                        User.username = username
                    }
                    if let companyname = json![CONSTANTS.JSON_KEYS.COMPANY_NAME] as? String {
                        User.companyName = companyname
                    }
                    self.performSegue(withIdentifier: CONSTANTS.SEGUES.TO_SEARCH_OPTIONS, sender: self)
                } else {
                    self.incorrectPassword()
                    Defaults[.automaticLogin] = false
                    self.username.isEnabled = true
                    self.password.isEnabled = true
                    self.loginButton.isUserInteractionEnabled = true
                }
            }
        })
    }
    func performLogin(){
        let username_text = self.username.text! 
        let pass_text = self.password.text! 
        self.loginButton.isUserInteractionEnabled = false
        if (!username_text.isEmpty && !pass_text.isEmpty) {
            login(username: username_text, password: pass_text, completion: { (json) in
                if let status = json![CONSTANTS.JSON_KEYS.API_STATUS] as? Int {
                    if status == 1 {
                        if let rank = json![CONSTANTS.JSON_KEYS.USER_RANK] as? Int {
                            User.setUserRank(rank: rank)
                        }
                        if let username = json![CONSTANTS.JSON_KEYS.USERNAME] as? String {
                            User.username = username
                        }
                        if let companyname = json![CONSTANTS.JSON_KEYS.COMPANY_NAME] as? String {
                            User.companyName = companyname
                        }
                        self.performSegue(withIdentifier: CONSTANTS.SEGUES.TO_SEARCH_OPTIONS, sender: self)
                        Defaults[.username] = username_text
                        Defaults[.password] = pass_text
                        Defaults[.automaticLogin] = true
                    } else {
                        self.incorrectPassword()
                        self.loginButton.isUserInteractionEnabled = true
                    }
                }
            })
        }
        else {
            print("username or password field empty")
            incorrectPassword()
            self.loginButton.isUserInteractionEnabled = true
            self.loginButton.isHighlighted = false
        }
    }
    func incorrectPassword() {
        self.username.layer.shake()
        self.password.layer.shake()
        self.username.text = ""
        self.password.text = ""
        self.username.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username{
            if textField.text != ""{
                password.becomeFirstResponder()
            }
        }else{
            textField.resignFirstResponder()
            performLogin()
        }
        return true
    }
    
}

