//
//  SearchResultsCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/18/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import Haneke
class SearchResultsCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var serialNumber: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var models: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonOver: UIButton!
    
    @IBOutlet var mainViewHeightContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addShadowToCell()
    }
    
    func addShadowToCell(){
        self.mainView.addShadow(radius: 4, opacity: 0.2, offset: CGSize(width: 0, height: 4), path: true)
    }
    
    func loadImage(url: NSURL) {
        self.productImage.image = UIImage() // CHANGE - Add placeholder Image
        self.productImage.hnk_setImageFromURL(url as URL)
        self.layoutSubviews()
    }
    
    func setHeightOfMainView(){
        mainViewHeightContraint.constant = 110 + 16 * CGFloat(self.models.numberOfLines)
    }

}
