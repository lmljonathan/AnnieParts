//
//  LoadingViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 8/13/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet var bgView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var indicationLabel: UILabel!
    
    var message: String!
    var bgColor: UIColor! = .darkGrayColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        
        bgView.backgroundColor = bgColor
        bgView.alpha = 0.8
        
        if bgColor == UIColor.whiteColor(){
            indicationLabel.textColor = UIColor.APdarkGray()
            activityIndicator.color = UIColor.APdarkGray()
        }
        
        self.activityIndicator.startAnimating()
        indicationLabel.text = message
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
