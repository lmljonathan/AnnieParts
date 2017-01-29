//
//  ProductDetailCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/22/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class ProductDetailCell: UITableViewCell {


    @IBOutlet weak var product_name: UILabel!
    @IBOutlet weak var product_serial: UILabel!
    @IBOutlet weak var product_make: UILabel!
    @IBOutlet weak var product_years: UILabel!
    @IBOutlet weak var product_models: UILabel!
    @IBOutlet weak var product_description: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initialize(data: Product) {
        product_name.text = data.name
        product_serial.text = data.serial_number
        product_make.text = data.make
        product_years.text = data.years
        product_models.text = data.models
    }
}
