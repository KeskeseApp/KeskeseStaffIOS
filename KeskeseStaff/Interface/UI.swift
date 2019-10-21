//
//  UI.swift
//  KeskeseStaff
//
//  Created by NI Vol on 7/30/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import Foundation
import UIKit

func animate(cell:UITableViewCell) {
    let view = cell.contentView
    view.layer.opacity = 0.5
    UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: { () -> Void in
        view.layer.opacity = 1
        
    }, completion: nil)
}
func animateCollectionCell(cell:UICollectionViewCell) {
    let view = cell.contentView
    view.layer.opacity = 0.5
    UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: { () -> Void in
        view.layer.opacity = 1
        
    }, completion: nil)
}

func presentPopup(popupVC : UIViewController, mainVC : UIViewController){
    popupVC.modalTransitionStyle = .crossDissolve
    popupVC.modalPresentationStyle = .overFullScreen
    mainVC.present(popupVC, animated: true, completion: nil)
}

//TextField
func singleLine(view : UIView , lineColor : UIColor){
    let bottomLine = CALayer()
    
    bottomLine.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 1)
    
    bottomLine.backgroundColor = lineColor.cgColor
    
    view.layer.addSublayer(bottomLine)
    
}


//Image
extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}
//Color

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

//View


extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

func fadeView(view : UIView, delay: TimeInterval, isHiden: Bool) {
    
    let animationDuration = 0.25
    
    // Fade in the view
    UIView.animate(withDuration: animationDuration, animations: { () -> Void in
        //        view.alpha = 1
    }) { (Bool) -> Void in
        
        // After the animation completes, fade out the view after a delay
        
        UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseOut, animations: { () -> Void in
            if isHiden{
                view.alpha = 0
            } else {
                view.alpha = 1
            }
        },
                       completion: nil)
    }
}
