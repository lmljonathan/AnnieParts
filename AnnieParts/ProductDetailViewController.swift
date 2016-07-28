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

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var imageCaroselScrollView: UIScrollView!
    
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var changeQuantityView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var aboutSelect: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNib("AboutView", toView: self.contentView)
        addTapGR(aboutSelect, action: Selector("switchToAbout:"))
        
        mainScrollView.contentSize = CGSizeMake(self.view.frame.width, 1000)
        mainScrollView.showsVerticalScrollIndicator = true
        mainScrollView.scrollEnabled = true
        
        self.addToCartView.layer.cornerRadius = 5.0
        self.changeQuantityView.layer.cornerRadius = 5.0
        
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
    
    
    func addNib(named: String, toView: UIView){
        let nibView = NSBundle.mainBundle().loadNibNamed(named, owner: self, options: nil)[0] as! UIView
        nibView.frame = toView.frame
        toView.addSubview(nibView)
    }
    
    func switchToAbout(gr: UITapGestureRecognizer){
        self.aboutSelect.subviews[0].removeFromSuperview()
        self.addNib("VideoView", toView: self.contentView)
    }
    
    private func addTapGR(view: UIView, action: Selector){
        let gr = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gr)
    }
    

}
