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
    
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var aboutSelect: UIView!
    @IBOutlet weak var videoSelect: UIView!
    @IBOutlet weak var installSelect: UIView!
    @IBOutlet weak var docsSelect: UIView!
    
    private var activeTab: UIView!
        
    override func viewDidLoad() {

        self.navigationController?.addSideMenuButton()
        let button = UIBarButtonItem()
        self.navigationItem.leftBarButtonItems?.insert(UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(ProductDetailViewController.unwind)), atIndex:0)
        
        activeTab = aboutSelect
        
        addNib("aboutSelect", toView: self.contentView)
        for tab in [aboutSelect, videoSelect, installSelect, docsSelect]{
            self.addTapGR(tab, action: #selector(ProductDetailViewController.switchTab(_:)))
        }
        
        // mainScrollView.contentSize = CGSizeMake(self.view.frame.width, 1000)
        mainScrollView.showsVerticalScrollIndicator = true
        mainScrollView.scrollEnabled = true
        
        self.addToCartView.layer.cornerRadius = 5.0
        self.changeQuantityView.layer.cornerRadius = 5.0
        imageCaroselScrollView.auk.settings.placeholderImage = UIImage(named: "placeholder")
        
        // Show remote images
        imageCaroselScrollView.auk.settings.pageControl.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        imageCaroselScrollView.auk.show(url: "https://bit.ly/auk_image")
        imageCaroselScrollView.auk.show(url: "https://bit.ly/moa_image")
        super.viewDidLoad()
    }

    func addNib(named: String, toView: UIView){
        let nibView = NSBundle.mainBundle().loadNibNamed(named, owner: self, options: nil)[0] as! UIView
        nibView.frame = toView.frame
        toView.addSubview(nibView)
    }
    
    func switchTab(gr: UITapGestureRecognizer){
        self.activeTab = gr.view!
        
        func hideOtherTabs(){
            for view in tabView.subviews{
                if view != self.activeTab{
                    let viewLabel = view.subviews[0] as! UILabel
                    view.backgroundColor = UIColor.darkGrayColor()
                    viewLabel.textColor = UIColor.whiteColor()
                }
            }
        }
        let viewLabel = activeTab.subviews[0] as! UILabel
        activeTab.backgroundColor = UIColor.whiteColor()
        viewLabel.textColor = UIColor.darkGrayColor()
        
        if contentView.subviews.count != 0{
            self.contentView.subviews[0].removeFromSuperview()
            
            switch activeTab {
            case aboutSelect:
                self.addNib("aboutSelect", toView: self.contentView)
                let view = self.contentView.subviews[0] as! aboutSelectView
                view.configure("There is no information at the moment.")
            case videoSelect:
                self.addNib("videoSelect", toView: self.contentView)
            case installSelect:
                self.addNib("aboutSelect", toView: self.contentView)
            case docsSelect:
                self.addNib("aboutSelect", toView: self.contentView)
            default:
                break
            }
        }
        
        hideOtherTabs()
    }
    
    private func addTapGR(view: UIView, action: Selector){
        let gr = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(gr)
    }
    func unwind() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    

}
