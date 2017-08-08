//
//  ShoppingCartCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/17/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyUtils

class ShoppingCartCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var serial_number: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantityButton: RoundedButton!
    @IBOutlet weak var deleteButton: RoundedButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!


    func initialize(data: ShoppingProduct) {
        loading.isHidden = true
        
        let image_url = URL(string: data.thumb_image_path)
        img.kf.setImage(with: image_url)
        name.text = data.name
        serial_number.text = data.serial_number
        quantity.text = "Quantity: " + String(data.quantity)
        price.text = data.price.formattedPrice
        price.isHidden = (User.sharedInstance.user_rank <= 1)
    }
}
