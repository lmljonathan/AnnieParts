//
//  ProductCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/13/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    @IBOutlet weak var product_cell_view: UIView!

    @IBOutlet weak var product_image: UIImageView!

    @IBOutlet weak var product_name: UILabel!
    @IBOutlet weak var product_serial_number: UILabel!
    @IBOutlet weak var product_make: UILabel!
    @IBOutlet weak var product_years: UILabel!
    @IBOutlet weak var product_models: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(data: Product) {
        product_name.text = data.name
        product_serial_number.text = data.serial_number
        product_make.text = data.make
        product_years.text = data.years
        product_models.text = data.models

        let image_url = URL(string: data.image_path)
        product_image.kf.setImage(with: image_url)

    }
}
