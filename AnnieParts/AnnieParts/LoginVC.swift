//
//  LoginVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var login_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.login_button.setTitleColor(UIColor.lightGray, for: .selected)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login_failure() {

    }
    
    @IBAction func login(_ sender: UIButton) {
        let username = self.username_field.text!
        let password = self.password_field.text!
        sender.isSelected = true
        if (!username.isEmpty && !password.isEmpty) {
            self.loading.startAnimating()
            login_request(username: username, password: password, completion: { (user, status) in
                if (status) {
                    print("hello")
                    //perform segue
                }
                else {
                    //feedback that login failed
                }
                sender.isSelected = false
                self.loading.stopAnimating()
            })
        }
        else {
            //feedback that login failed
        }
    }
}
