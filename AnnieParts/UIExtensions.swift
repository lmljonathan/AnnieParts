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
    
//    public class func selectedGray() -> UIColor{
//        return UIColor(netHex: 0xd5d5d5)
//    }
    
    static var selectedGray: UIColor {
        return UIColor(netHex: 0xd5d5d5)
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
    
    func addShadow(radius: CGFloat = 3, opacity: Float = 0.3, offset: CGSize = CGSize.zero, path: Bool = false){
        if path{
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }
        self.layer.shadowColor = UIColor.black.cgColor
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
        self.transform = CGAffineTransform(translationX: x - self.x, y: y - self.y)
    }
    
    func disable(){
        self.backgroundColor = .gray
        self.isUserInteractionEnabled = false
    }
    
    func enable(color: UIColor){
        self.backgroundColor = color
        self.isUserInteractionEnabled = true
    }
    
    func highlight(){
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.6
        }
    }
    
    func normalize(){
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    func addTapGestureRecgonizer(action: Selector, completion: (_ gr: UITapGestureRecognizer) -> Void){
        let gr = UITapGestureRecognizer(target: self, action: action)
        self.addGestureRecognizer(gr)
        completion(gr)
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
        let textColor: UIColor = UIColor.red
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        //Setup the image context using the passed image.
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(toImage.size, false, scale)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]
        
        // Draw Circle
        let context = UIGraphicsGetCurrentContext()
        let rectangle = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        context!.addEllipse(in: rectangle)
        context!.drawPath(using: .fill)
        context!.setFillColor(UIColor.red.cgColor)
        
        //Put the image into a rectangle as large as the original image.
        toImage.draw(in: CGRect(x: 0, y: 0, width: toImage.size.width, height: toImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: toImage.size.width, height: toImage.size.height)
        
        //Now Draw the text into an image.
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
    }
    
    func addBadge(){
        self.image = addText(drawText: "1", toImage: self.image!, atPoint: CGPoint(x: 0,y: 0))
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
        self.reloadSections(NSIndexSet(index: section) as IndexSet, with: animation)
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
        self.isUserInteractionEnabled = true
    }
    
    override func disable() {
        self.isUserInteractionEnabled = false
    }
    
    func hide(){
        for view in (self.subviews){
            view.isHidden = true
        }
    }
    
    func show(){
        for view in (self.subviews){
            view.isHidden = false
        }
    }
}

extension UIFont{
    public class func Montserrat(size: CGFloat = 12) -> UIFont{
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
}

extension UIViewController{
    
    func showNotificationView(message: String, image: UIImage, completion: @escaping (_ vc: UIViewController) -> Void){
        self.definesPresentationContext = true
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "notificationVC") as! NotificationDialogViewController
        vc.setImage = image
        vc.message = message
        customPresentViewController(notificationPresentr(), viewController: vc, animated: true) {
            completion(vc)
        }
    }
    
    func showLoadingView(message: String, bgColor: UIColor = UIColor.APdarkGray() , completion: @escaping (_ loadingVC: UIViewController) -> Void){
        self.definesPresentationContext = true
        let loadingVC = self.storyboard?.instantiateViewController(withIdentifier: CONSTANTS.VC_IDS.LOGIN_LOADING) as! LoadingViewController
        loadingVC.message = message
        loadingVC.bgColor = bgColor
        customPresentViewController(notificationPresentr(), viewController: loadingVC, animated: true) {
            completion(loadingVC)
        }
    }
    
    func delayDismiss(seconds: Double){
        func delay(delay:Double, closure:@escaping ()->()) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                closure()
            }
        }
        
//            dispatch_after(
//                DispatchTime.now(
//                    DispatchTime(uptimeNanoseconds: .now()),
//                    Int64(delay * Double(NSEC_PER_SEC))
//                ),
//                DispatchQueue.main, closure)
//        }
        
        delay(delay: seconds) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

