//
//  ProductDescriptionCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 4/26/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class ProductDescriptionCell: UITableViewCell {

    @IBOutlet weak var product_description: UILabel!

    func initializeProductDescription(product: Product) {
        product_description.text = product.description
    }
}
