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
    @IBOutlet var cancelButton: UIButton!
    
    @IBAction func confirmButtonPressed(sender: AnyObject) {
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.mainView.addShadow(radius: 4, opacity: 0.2, offset: CGSize(width: 0, height: 4), path: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(order: Order){
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        self.createdByLabel.text = "Created By " + String(order.userID)
        self.orderNumLabel.text = "Order #" + String(order.sn)
        self.totalPriceLabel.text = formatter.string(from: order.totalPrice as NSNumber)
    }
    
    func configureWithProcessedOrder(processedOrder: ProcessedOrder){
        self.configureWith(order: processedOrder)
        self.statusLabel.text = "Status: " + processedOrder.status
    }

}
