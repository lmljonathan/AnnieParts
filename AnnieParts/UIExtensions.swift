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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    public class func APdarkGray() -> UIColor{
        return UIColor(netHex: 0x303030)
    }
    
    public class func APmediumGray() -> UIColor{
        return UIColor(netHex: 0x444444)
    }
    
    public class func APlightGray() -> UIColor{
        return UIColor(netHex: 0x6a6a6a)
    }
    
    public class func APred() -> UIColor{
        return UIColor(netHex: 0xbb3b3b)
    }
    
}

extension UIView{
    func disable(){
        self.backgroundColor = .grayColor()
        self.userInteractionEnabled = false
    }
    
    func enable(color: UIColor){
        self.backgroundColor = color
        self.userInteractionEnabled = true
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

extension UITableViewCell{
    func enable(){
        self.userInteractionEnabled = true
    }
    
    override func disable() {
        self.userInteractionEnabled = false
    }
}

