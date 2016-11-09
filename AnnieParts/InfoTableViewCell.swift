//
//  InfoTableViewCell.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 8/23/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
