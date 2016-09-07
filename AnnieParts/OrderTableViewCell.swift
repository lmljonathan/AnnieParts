//
//  OrderTableViewCell.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 9/6/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var orderNumLabel: UILabel!
    @IBOutlet var createdByLabel: UILabel!
    @IBOutlet var itemNumLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var confirmButton: UIButton!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.mainView.addShadow(4, opacity: 0.2, offset: CGSize(width: 0, height: 4), path: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
