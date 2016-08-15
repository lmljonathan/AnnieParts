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

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var serialNumber: UILabel!
    @IBOutlet weak var manufacturer: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var models: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadImage(url: NSURL) {
        self.productImage.image = UIImage() // CHANGE - Add placeholder Image
        self.productImage.hnk_setImageFromURL(url)
        self.layoutSubviews()
    }

}
