//
//  MenuCellTableViewCell.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 8/13/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class MenuCellTableViewCell: UITableViewCell {

    @IBOutlet var menuLabel: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
