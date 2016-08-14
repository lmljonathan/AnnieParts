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
    var delegate: PassBackOptionDelegate?
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
        self.titleLabel.text = title
    }
    
    func showDropDown(selectorData: [String]){
        setupDropDown(selectView, data: selectorData)
        dropDown.show()
    }
    
    func clear(){
        self.selectLabel.text = "Select One"
    }
    
    private func setupDropDown(view: UIView, data: [String]){
     
        // The view to which the drop down will appear on
        dropDown.anchorView = view // UIView or UIBarButtonItem
        dropDown.direction = .Bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:view.bounds.height)
        dropDown.cellHeight = 44
        dropDown.textColor = UIColor.whiteColor()
        dropDown.textFont = UIFont.Montserrat(15)
        dropDown.backgroundColor = UIColor.APlightGray()
        
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.selectLabel.text = item
            self.delegate?.selectOption(self, option: item)
        }
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = data
    }

    

}
