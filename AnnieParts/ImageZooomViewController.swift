//
//  ImageZooomViewController.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/24/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import moa
class ImageZooomViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var imagePath: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        configureNavBarBackButton(self.navigationController!, navItem: self.navigationItem)
        self.imageView.moa.url = self.imagePath
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
