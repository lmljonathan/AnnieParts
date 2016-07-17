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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPassButton: UIButton!
    
    // MARK: - View Loading Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
    }
    
    // MARK: - IB Outlet Actions
    
    @IBAction func loginPressed(sender: UIButton) {
        self.checkCredentials()
    }
    
    @IBAction func forgetPasswordPressed(sender: UIButton) {
        
    }
    
    // MARK: - Main Functions
    
    func checkCredentials(){
        if true { // Insert post request
            self.performSegueWithIdentifier("pushToSearch", sender: self)
        }else{
            // Display error
        }
    }
}

