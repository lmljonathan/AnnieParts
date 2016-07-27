//
//  SelectorTableViewCell.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/19/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import DropDown

class SelectorTableViewCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Variables
    private var dropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Configure Function
    func configureCell(title: String){
        self.selectView.layer.cornerRadius = 5
        self.titleLabel.text = title
    }
    
    func showDropDown(selectorData: [String]){
        setupDropDown(selectView, data: selectorData)
        dropDown.show()
    }
    
    private func setupDropDown(view: UIView, data: [String]){
        // The view to which the drop down will appear on
        dropDown.anchorView = view // UIView or UIBarButtonItem
        dropDown.direction = .Bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:view.bounds.height)
        dropDown.cellHeight = 44
        dropDown.backgroundColor = UIColor.lightGrayColor()
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.selectLabel.text = item
        }
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = data
    }
    

}
