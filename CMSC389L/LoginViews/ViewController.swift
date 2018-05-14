//
//  ViewController.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 4/15/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSUserPoolsSignIn
import AWSMobileClient

class ViewController: UIViewController, UITextFieldDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate {
    private let pool = AWSCognitoIdentityUserPool.init(forKey: "UserPool")
    
    override func viewDidLoad() {
   
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        pool.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyboard), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {

        let currentUser = pool.currentUser()
        
//        if(currentUser != nil) {
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "phototaker", sender: self)
//            }
//        }
        
//        AWSSignInManager.sharedInstance().logout { (k, logo) in
//
//        }
//      
//            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: nil) { (provider, error) in
//                if(error != nil){
//                    print(error)
//                }else{
//                    print(provider.isLoggedIn)
//                }
//            }
        
        
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if (!passwordTextField.isFirstResponder && !loginTextField.isFirstResponder) { return }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {

                self.bigImageViewBottomConstraint.constant = 100
                self.createButtonBottomConstraint.constant = self.keyboardHeight
                
                self.topImageView.layoutIfNeeded()
                self.view.layoutIfNeeded()

            }, completion: nil)
      
            
            isKeyboardShown = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet private weak var bigImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var createButtonBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var topImageView: UIView!
    
    var keyboardHeight : CGFloat = 0.0
    private var isKeyboardShown = false
    
    @IBOutlet private weak var loginTextField: LoginTextField!
    @IBOutlet private weak var passwordTextField: LoginTextField!
    
    private var previousTopLoginViewConstraint : CGFloat = 0.0
    private var previousBigImageViewBottomConstraint : CGFloat = 0.0
    private var previousCreateButtonBottomConstraint : CGFloat = 0.0
    
    @objc func dismissKeyboard() {
        if(isKeyboardShown)
        {
            isKeyboardShown = false
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.bigImageViewBottomConstraint.constant = self.previousBigImageViewBottomConstraint
                self.createButtonBottomConstraint.constant = self.previousCreateButtonBottomConstraint
                
                self.view.layoutIfNeeded()
                self.topImageView.layoutIfNeeded()
                
                self.view.endEditing(true)
            }, completion: nil)
        
        }
    }
    

    @IBAction func loginBT(_ sender: UIButton) {
        let email = loginTextField.text!
        let password = passwordTextField.text!
        
        let pool = AWSCognitoIdentityUserPool.init(forKey: "UserPool")
        let user = pool.getUser()
        
        (user.getSession(email, password: password, validationData: nil).continueWith(block: { (task) -> Any? in
            DispatchQueue.main.async(execute: {
                if let error = task.error {
                    print(error)
                }
                
                if let result = task.result {
                    self.performSegue(withIdentifier: "phototaker", sender: self)
                }
            })
            return nil
        }))
        
        
    }
    
 
    
}

