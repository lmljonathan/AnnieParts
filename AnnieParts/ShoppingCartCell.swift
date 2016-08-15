//
//  ShoppingCartCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/24/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class ShoppingCartCell: UITableViewCell {

    @IBOutlet var quantitySelectView: UIView!
    
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var serialNumber: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var models: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var changeQuantityButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(){
//        quantitySelectView.layer.cornerRadius = 5.0
//        deleteButton.layer.cornerRadius = 5.0
    }
    func loadImage(url: NSURL) {
        self.productImage.hnk_setImageFromURL(url)
        self.layoutSubviews()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
