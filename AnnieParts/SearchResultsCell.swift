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
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.addShadowToCell()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func addShadowToCell(){
        self.mainView.addShadow(4, opacity: 0.2, offset: CGSize(width: 0, height: 4), path: true)
    }
    
    func loadImage(url: NSURL) {
        self.productImage.image = UIImage() // CHANGE - Add placeholder Image
        self.productImage.hnk_setImageFromURL(url)
        self.layoutSubviews()
    }
    
    func setHeightOfMainView(){
        mainViewHeightContraint.constant = 110 + 16 * CGFloat(self.models.numberOfLines)
    }

}
