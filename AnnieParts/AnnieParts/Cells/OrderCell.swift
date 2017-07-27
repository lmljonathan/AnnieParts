//
//  OrderCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/26/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit
import SwiftyUtils

class OrderCell: UITableViewCell {

    @IBOutlet weak var order_number: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initialize(order: Order) {
        order_number.text = order.serial_number
        date.text = ""
        total.text = "Order Total: \(order.total.formattedPrice)"
    }
    
}
