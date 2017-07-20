//
//  WebViewVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    var path: String!
    var loading: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
        loading = startActivityIndicator(view: self.view)
        let encoded_url = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = NSURL(string: encoded_url!)
        let request = NSURLRequest(url: url! as URL)
        webview.loadRequest(request as URLRequest)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
    }
}
