//
//  ShoppingCartCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 7/17/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class ShoppingCartCell: UITableViewCell {


    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var serial_number: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var years: UILabel!
    @IBOutlet weak var models: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantityButton: UIButton!

    @IBAction func deleteItem(_ sender: UIButton) {

    }
}
