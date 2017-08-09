//
//  LoadingVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/9/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    override func viewDidLoad() {
        background.layer.cornerRadius = 5
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startLoading() {
        print("start")
        self.status.isHidden = true
        self.loading.startAnimating()
    }

    func stopLoading(text: String) {
        print("stop")
        self.loading.stopAnimating()
        self.status.isHidden = false
        self.status.text = text
    }
}
