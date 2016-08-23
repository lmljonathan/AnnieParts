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
    var url: NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView = WKWebView()
        self.view = self.webView
        
        //let encodedURL = self.urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        //let url = NSURL(string: encodedURL)!
        let req = NSURLRequest(URL:url)
        self.webView!.loadRequest(req)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
}
