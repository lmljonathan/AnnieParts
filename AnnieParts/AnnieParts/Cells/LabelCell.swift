//
//  LabelCell.swift
//  AnnieParts
//
//  Created by Ryan Yue on 1/26/17.
//  Copyright © 2017 boyang. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    func initialize(title: String) {
        if (title.isEmpty) {
            label.text = "Title"
        }
        else {
            label.text = title
        }
    }

}
