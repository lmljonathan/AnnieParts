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
        configureNavBarBackButton(self.navigationController!, navItem: self.navigationItem)
        self.webView = WKWebView()
        self.view = self.webView
        
        url = self.url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let encodedURL = NSURL(string: url)! ?? NSURL()
        let req = NSURLRequest(URL: encodedURL)
        self.webView!.loadRequest(req)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
}
