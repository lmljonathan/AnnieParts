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
    
    func highlight(){
        UIView.animateWithDuration(0.5) {
            self.alpha = 0.6
        }
    }
    
    func normalize(){
        UIView.animateWithDuration(0.5) {
            self.alpha = 1
        }
    }
    
    func addTapGestureRecgonizer(action: Selector, completion: (gr: UITapGestureRecognizer) -> Void){
        let gr = UITapGestureRecognizer(target: self, action: action)
        self.addGestureRecognizer(gr)
        completion(gr: gr)
    }
    
    func becomeFirstResponderWithOptions(completion: () -> Void){
        self.becomeFirstResponder()
        completion()
    }
    
    func changeWidth(constraint: NSLayoutConstraint, width: CGFloat){
        self.layoutIfNeeded()
        constraint.constant = width
        self.layoutIfNeeded()
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

extension UITableView{
    func hide(){
        for cell in self.visibleCells{
            cell.hide()
        }
    }
    
    func show(){
        for cell in self.visibleCells{
            cell.show()
        }
    }
}

extension UITableViewCell{
    func enable(){
        self.userInteractionEnabled = true
    }
    
    override func disable() {
        self.userInteractionEnabled = false
    }
    
    func hide(){
        for view in (self.subviews){
            view.hidden = true
        }
    }
    
    func show(){
        for view in (self.subviews){
            view.hidden = false
        }
    }
}

extension UIFont{
    public class func Montserrat(size: CGFloat = 12) -> UIFont{
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
}

extension UIViewController{
    
    func showNotificationView(message: String, image: UIImage, completion: (vc: UIViewController) -> Void){
        self.definesPresentationContext = true
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("notificationVC") as! NotificationDialogViewController
        vc.setImage = image
        vc.message = message
        customPresentViewController(blurredPresentr(), viewController: vc, animated: true) {
            completion(vc: vc)
        }
    }
    
    func showLoadingView(message: String, bgColor: UIColor = UIColor.APdarkGray() , completion: (loadingVC: UIViewController) -> Void){
        self.definesPresentationContext = true
        let loadingVC = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.LOGIN_LOADING) as! LoadingViewController
        loadingVC.message = message
        loadingVC.bgColor = bgColor
        customPresentViewController(blurredPresentr(), viewController: loadingVC, animated: true) {
            completion(loadingVC: loadingVC)
        }
    }
    
    func delayDismiss(seconds: Double){
        func delay(delay:Double, closure:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(), closure)
        }
        
        delay(seconds) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

