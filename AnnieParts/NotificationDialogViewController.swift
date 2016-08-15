//
//  NotificationDialogViewController.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 8/14/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import UIKit

class NotificationDialogViewController: UIViewController {
    
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var indicationLabel: UILabel!
    
    var setImage: UIImage!
    var message: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = setImage
        indicationLabel.text = message
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
