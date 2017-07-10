//
//  WebViewVC.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/10/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    var path: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let loading = startActivityIndicator(view: self.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
