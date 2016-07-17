//
//  SearchByViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/17/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit
import DropDown

class SearchByViewController: UIViewController {
    
    // MARK: - IB Outlets

    @IBOutlet weak var selectView: UIView!
    
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Search By"
        
        // UIGestureRecognizer
        
        let selectGR = UITapGestureRecognizer(target: self, action: "activateDropDown:")
        self.selectView.addGestureRecognizer(selectGR)
        
    }
    
    func activateDropDown(gr: UITapGestureRecognizer){
        // The view to which the drop down will appear on
        dropDown.anchorView = selectView // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        
        dropDown.show()
    }
    
    

}
