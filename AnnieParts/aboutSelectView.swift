//
//  aboutSelectView.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 7/29/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class aboutSelectView: UIView {
    
    @IBOutlet weak var aboutTextField: UITextView!
    
    func configure(text: String){
        self.aboutTextField.text = text
    }
}
