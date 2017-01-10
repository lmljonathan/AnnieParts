//
//  SearchOptionsHeaderCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 8/23/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class SearchOptionsHeaderCell: UITableViewCell {

    
    @IBOutlet weak var expandedSymbol: UILabel!
    @IBOutlet weak var selectedOption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
