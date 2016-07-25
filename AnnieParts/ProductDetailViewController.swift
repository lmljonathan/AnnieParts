//
//  ProductDetailViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/25/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Auk

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var imageCaroselScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageCaroselScrollView.frame.size.width = self.view.frame.width * 0.8
        imageCaroselScrollView.auk.settings.placeholderImage = UIImage(named: "placeholder")
        
        // Show remote images
        imageCaroselScrollView.auk.settings.pageControl.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        imageCaroselScrollView.auk.show(url: "https://bit.ly/auk_image")
        imageCaroselScrollView.auk.show(url: "https://bit.ly/moa_image")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
