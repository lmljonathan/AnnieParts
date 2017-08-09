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
    class func silver() -> UIColor {
        return UIColor(colorLiteralRed: 220.0/255.0, green: 220.0/255.0, blue: 250.0/255.0, alpha: 1)
    }
    class func maroon() -> UIColor {
        return UIColor(colorLiteralRed: 152.0/255.0, green: 13.0/255.0, blue: 16.0/255.0, alpha: 1)
    }
    class func light_maroon() -> UIColor {
        return UIColor(colorLiteralRed: 176.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1)
    }
    class func light_red() -> UIColor {
        return UIColor(colorLiteralRed: 150.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1)
    }
    class func darker_silver() -> UIColor {
        return UIColor(colorLiteralRed: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1)
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
    func makeTranslation(x: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(translationX: x - self.x, y: y - self.y)
    }
}
extension CALayer {
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

extension UITableView {
    func reloadDataInSection(section: Int){
        self.beginUpdates()
        self.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        self.endUpdates()
    }
}


