//
//  WebViewViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 8/23/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    var webView: WKWebView?
    var url: String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarBackButton(sender: self.navigationController!, navItem: self.navigationItem)
        self.webView = WKWebView()
        self.view = self.webView
        
        url =
            
            self.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let encodedURL = NSURL(string: url)! 
        let req = NSURLRequest(url: encodedURL as URL)
        self.webView!.load(req as URLRequest)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}
