//
//  OrderInfoCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/1/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import SwiftyUtils

class OrderInfoCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initalize(orderitem: OrderItem) {
        name.text = orderitem.name
        if (orderitem.quantity == 0) {
            quantity.text = ""
        }
        else {
            quantity.text = String(orderitem.quantity)
        }
        price.text = orderitem.price.formattedPrice
    }
}
