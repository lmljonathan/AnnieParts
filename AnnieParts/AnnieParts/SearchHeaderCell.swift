//
//  SearchHeaderCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/13/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class SearchHeaderCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var expand_symbol: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initialize(expanded: Bool) {
        self.title.text = "选择"
        if (expanded) {
            self.expand_symbol.text = "-"
        }
        else {
            self.expand_symbol.text = "+"
        }
    }

}
