//
//  LineView.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 4/16/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit
@IBDesignable
class LineView: UILabel {

    @IBInspectable var borderColor : UIColor {
        get {
            return UIColor(white: 105/255, alpha: 1)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat {
        get {
            return 4
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    
    override func layoutSubviews() {

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
