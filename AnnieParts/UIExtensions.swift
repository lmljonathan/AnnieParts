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
    var y: CGFloat! {
        get {
            return self.frame.origin.y
        }
        set(y) {
            self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.width, height: self.frame.height)
        }
    }
    
    var centerY: CGFloat! {
        get {
            return self.frame.midY
        }
        set(newCenterY) {
            self.frame = CGRect(x: self.frame.origin.x, y: newCenterY - self.frame.height / 2, width: self.frame.width, height: self.frame.height)
        }
    }
    
    var x: CGFloat! {
        get {
            return self.frame.origin.x
        }
        set(x) {
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
    }
    
    var height: CGFloat! {
        get {
            return self.frame.height
        }
        set(height) {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: height)
        }
    }
    
    func addShadow(radius: CGFloat = 3, opacity: Float = 0.3, offset: CGSize = CGSizeZero, path: Bool = false){
        if path{
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).CGPath
        }
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
        if self.superview?.clipsToBounds == true{
            print("WARNING: Clips to bounds must be false in order for shadow to be drawn")
        }
    }
    
    func hideShadow(){
        self.layer.shadowOpacity = 0
    }
    
    func showShadow(opacity: Float){
        self.layer.shadowOpacity = opacity
    }
    
    
    func makeTranslation(x: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransformMakeTranslation(x - self.x, y - self.y)
    }
    
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
        let textColor: UIColor = UIColor.redColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 12)!
        
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
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, toImage.size.width, toImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
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
    
    func reloadDataWithAutoSizingCells(){
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
    
    func reloadSectionWithAutoSizingCells(section: Int, animation: UITableViewRowAnimation) {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadSections(NSIndexSet(index: section), withRowAnimation: animation)
    }
    
    
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
        customPresentViewController(notificationPresentr(), viewController: vc, animated: true) {
            completion(vc: vc)
        }
    }
    
    func showLoadingView(message: String, bgColor: UIColor = UIColor.APdarkGray() , completion: (loadingVC: UIViewController) -> Void){
        self.definesPresentationContext = true
        let loadingVC = self.storyboard?.instantiateViewControllerWithIdentifier(CONSTANTS.VC_IDS.LOGIN_LOADING) as! LoadingViewController
        loadingVC.message = message
        loadingVC.bgColor = bgColor
        customPresentViewController(notificationPresentr(), viewController: loadingVC, animated: true) {
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

