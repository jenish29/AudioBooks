//
//  NewAccountButton.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 4/15/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit

@IBDesignable
class NewAccountButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var color : UIColor {
        get {
            return UIColor(red: 84/255, green: 107/255, blue: 217/255, alpha: 1)
        }
        set {
           self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var backgroundColorC : UIColor {
        get {
            return UIColor(red: 84/255, green: 107/255, blue: 217/255, alpha: 1)
        }
        set {
            self.backgroundColor = newValue
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set{
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth : CGFloat {
        get {
            return 1
        }
        
        set{
            self.layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable var bottomBorderWidth : CGFloat {
        get {
            return 1
        }
        
        set {
            bottomBorder.borderWidth = bottomBorderWidth
        }
     }
    
    @IBInspectable var bottomBorderColor : UIColor {
        get {
            return UIColor.white
        }
        
        set{
            bottomBorder.borderColor = newValue.cgColor
        }
    }
    
    var bottomBorderColorCGcolor : CGColor {
        get {
            return bottomBorder.borderColor!
        }
        set{
            bottomBorder.borderColor = newValue
        }
    }
    
    
    private var bottomBorder : CALayer = CALayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.frame = CGRect(x: 0.0, y: self.frame.size.height-1, width: self.frame.size.width , height: 1.0)
        self.layer.addSublayer(bottomBorder)
    }
}
