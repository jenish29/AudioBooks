//
//  LoginTextField.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 4/15/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {
    
    @IBInspectable var borderWidth : CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor {
        get {
            return UIColor.white
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return 3
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

    
    //indenting bounds
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
