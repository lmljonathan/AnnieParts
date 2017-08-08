//
//  LoginVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var login_button: UIButton!
    @IBOutlet weak var annieparts_logo: UIImageView!
    @IBOutlet weak var annieparts_label: UILabel!
    private var original_frames: [UIView: CGFloat]?

    override func viewDidLoad() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(colorLiteralRed: 20.0/255.0, green: 24.0/255.0, blue: 35.0/255.0, alpha: 1).cgColor, UIColor(colorLiteralRed: 53.0/255.0, green: 53.0/255.0, blue: 73.0/255.0, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        self.view.layer.addSublayer(gradient)
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)

        self.username_field.delegate = self
        self.password_field.delegate = self
        self.username_field.layer.cornerRadius = 20
        self.password_field.layer.cornerRadius = 20
        self.login_button.layer.cornerRadius = 20
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        RequestHandler.cart_refresh = true
        self.original_frames = [self.username_field: self.username_field.y, self.password_field: self.password_field.y, self.login_button: self.login_button.y, self.loading: self.loading.y]
    }

    @IBAction func login(_ sender: UIButton) {
        request_login()
    }

    func keyboardWillShow(notification: NSNotification) {
        if self.username_field.y != 50{
            if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                self.annieparts_logo.isHidden = true
                self.annieparts_label.isHidden = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.username_field.makeTranslation(x: self.username_field.x, y: 50)
                    self.password_field.makeTranslation(x: self.password_field.x, y: self.username_field.frame.maxY + 10)
                    self.login_button.makeTranslation(x: self.login_button.x, y: self.password_field.frame.maxY + 13)
                    self.loading.makeTranslation(x: self.loading.x, y: self.login_button.centerY - 10)
                })
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if original_frames != nil{
            self.annieparts_logo.isHidden = false
            self.annieparts_label.isHidden = false
            for view in original_frames!.keys{
                UIView.animate(withDuration: 0.5, animations: {
                    view.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.username_field{
            if textField.text != ""{
                self.password_field.becomeFirstResponder()
            }
        }else{
            textField.resignFirstResponder()
            request_login()
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.resignFirstResponder()
    }

    func login_failure() {
        self.username_field.layer.shake()
        self.password_field.layer.shake()
        self.username_field.text = ""
        self.password_field.text = ""
        self.username_field.becomeFirstResponder()
    }

    func request_login() {
        let username = self.username_field.text!
        let password = self.password_field.text!
        self.login_button.isSelected = true
        if (!username.isEmpty && !password.isEmpty) {
            self.loading.startAnimating()
            login_request(username: username, password: password, completion: { (success) in
                if (success) {
                    self.performSegue(withIdentifier: "showTabBar", sender: nil)
                } else {
                    self.login_button.isSelected = false
                    self.loading.stopAnimating()
                    self.login_failure()
                }
                self.login_button.isSelected = false
                self.loading.stopAnimating()
            })
        }
        else {
            login_failure()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showTabBar") {
            if let destination = segue.destination as? UITabBarController {
                configureTabBar(tab: destination)
            }
        }
    }
}
