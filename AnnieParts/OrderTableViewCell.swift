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
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var confirmButton: UIButton!
    
    @IBAction func confirmButtonPressed(sender: AnyObject) {
        print("confirm pressed")
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.mainView.addShadow(4, opacity: 0.2, offset: CGSize(width: 0, height: 4), path: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(order: Order){
        self.createdByLabel.text = "Created By" + String(order.userID)
        self.orderNumLabel.text = "Order #" + String(order.id)
        self.totalPriceLabel.text = "$" + String(order.totalPrice)
    }
    
    func configureWithProcessedOrder(processedOrder: ProcessedOrder){
        self.configureWith(processedOrder)
        self.statusLabel.text = "Status: " + processedOrder.status
    }

}
