//
//  UIExtensions.swift
//  AnnieParts
//
//  Created by Jonathan Lam on 8/12/16.
//  Copyright © 2016 Boyang. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIImage{
    
    func addBadge(){
        
    }
}

extension UIBarButtonItem{
    
    func addText(drawText: NSString, toImage: UIImage, atPoint:CGPoint) -> UIImage{
        
        // Setup the font specific variables
        var textColor: UIColor = UIColor.redColor()
        var textFont: UIFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        //Setup the image context using the passed image.
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(toImage.size, false, scale)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]
        
        // Draw Circle
        let context = UIGraphicsGetCurrentContext()
        let rectangle = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        CGContextAddEllipseInRect(context, rectangle)
        CGContextDrawPath(context, .Fill)
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        
        //Put the image into a rectangle as large as the original image.
        toImage.drawInRect(CGRectMake(0, 0, toImage.size.width, toImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        var rect: CGRect = CGRectMake(atPoint.x, atPoint.y, toImage.size.width, toImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
    }
    
    func addBadge(){
        self.image = addText("1", toImage: self.image!, atPoint: CGPoint(x: 0,y: 0))
    }
    
}
