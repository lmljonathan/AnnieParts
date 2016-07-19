//
//  SelectorTableViewCell.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/19/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class SelectorTableViewCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Configure Function
    func configureCell(){
        self.selectView.layer.cornerRadius = 5
    }

}
