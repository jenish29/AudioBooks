//
//  PasswordTextField.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 4/16/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit

class PasswordTextField: LoginTextField {

    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }

}
