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
        let request = NSURLRequest(url: url as! URL)
        webview.loadRequest(request as URLRequest)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
