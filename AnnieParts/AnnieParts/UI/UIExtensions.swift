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
extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }

        border.backgroundColor = color.cgColor;

        self.addSublayer(border)
    }
    func shake(duration: TimeInterval = TimeInterval(0.5)) {

        let animationKey = "shake"
        removeAnimation(forKey: animationKey)

        let kAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        kAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        kAnimation.duration = duration

        var needOffset = frame.width * 0.05,
        values = [CGFloat]()

        let minOffset = needOffset * 0.1

        repeat {

            values.append(-needOffset)
            values.append(needOffset)
            needOffset *= 0.6
        } while needOffset > minOffset

        values.append(0)
        kAnimation.values = values
        add(kAnimation, forKey: animationKey)
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

