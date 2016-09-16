//
//  ProductDetailMainInfoCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 9/15/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class ProductDetailMainInfoCell: UITableViewCell {

    @IBOutlet weak var photoBrowserView: UIScrollView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var serialNumber: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var brief_description: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
