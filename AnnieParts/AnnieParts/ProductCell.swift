//
//  ProductCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/13/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var product_cell_view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        product_cell_view.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 2.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
