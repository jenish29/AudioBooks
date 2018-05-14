//
//  SignUpViewController.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 4/16/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSUserPoolsSignIn
import AWSMobileClient

class SignUpViewController: UIViewController, UITextFieldDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        isEmailedPressed = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var isEmailedPressed = true
    @IBOutlet weak var emailButton: NewAccountButton!
    @IBOutlet weak var passwordButton: NewAccountButton!
    @IBOutlet weak var nextButton: NewAccountButton!
    @IBOutlet weak var signUpButton: NewAccountButton!
    
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    
    @IBAction func switchViews(_ sender: Any) {
        let button = sender as! UIButton
        print(button == nextButton)
        if button == emailButton && !isEmailedPressed {
            emailPressed()
        }else if button == passwordButton || button == nextButton {
            passwordButtonPressed()
            emailTextField.resignFirstResponder()
        }
    }
    
    private func emailPressed() {
        switchColorButton(button: passwordButton, button1: emailButton)
        switchBottomBorderColor(button: passwordButton, button1: emailButton)
        
        nextButton.alpha = 1
        signUpButton.alpha = 0
        
        emailTextField.alpha = 1
        passwordTextField.alpha = 0
        
        isEmailedPressed = true
    }
    
    private func passwordButtonPressed(){
        switchColorButton(button: emailButton, button1: passwordButton)
        switchBottomBorderColor(button: emailButton, button1: passwordButton)
        
        nextButton.alpha = 0
        signUpButton.alpha = 1
        
        emailTextField.alpha = 0
        passwordTextField.alpha = 1
        
        isEmailedPressed = false
    }
    
    func switchColorButton(button: UIButton, button1: UIButton) {
        let tempFontColor = button1.titleLabel?.textColor
        
        button1.setTitleColor(button.titleLabel?.textColor, for: .normal)
        button.setTitleColor(tempFontColor, for: .normal)
    }
    
    func switchBottomBorderColor(button: NewAccountButton, button1: NewAccountButton) {
        let tempBottomBorderColor = button1.bottomBorderColorCGcolor
        
        button1.bottomBorderColorCGcolor = button.bottomBorderColorCGcolor
        button.bottomBorderColorCGcolor = tempBottomBorderColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
 
    
    func showAlert(messgae:String, messageCode : Int) {
        let alertController = UIAlertController(title: "Oops", message: messgae, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true) {
            switch messageCode {
            case 1:self.emailPressed()
                break
            default: break
            }
        }
        
    }
    
    @IBOutlet weak var invalidPasswordBlur: UIVisualEffectView!
    @IBOutlet var typesOfPasswordCharacter: [UILabel]!
    
    func isPasswordValid(_ password : String) -> Bool {
        
        var found = true
        
        let upperCaseTest = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        if(!upperCaseTest.evaluate(with: password)) {
            typesOfPasswordCharacter[0].textColor = UIColor.red
            found = false
        }else{
            typesOfPasswordCharacter[0].textColor = UIColor.green
        }
        
        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", ".*[$@$#!%*?&]+.*")
        if(!specialCharacterTest.evaluate(with: password)) {
            typesOfPasswordCharacter[1].textColor = UIColor.red
            found = false
        }else{
            typesOfPasswordCharacter[1].textColor = UIColor.green
        }
        
        let numberTest = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        if(!numberTest.evaluate(with: password)) {
            typesOfPasswordCharacter[2].textColor = UIColor.red
            found = false
        }else{
            typesOfPasswordCharacter[2].textColor = UIColor.green
        }
        
        let length = password.count
        if(length < 8){
            typesOfPasswordCharacter[3].textColor = UIColor.red
            found = false
        }else{
            typesOfPasswordCharacter[3].textColor = UIColor.green
        }
        
        if(!found){
            invalidPasswordBlur.alpha = 1
            passwordTextField.resignFirstResponder()
        }
        
        return found
    }
    
    @IBAction func unBlurImage(_ sender: Any) {
        invalidPasswordBlur.alpha = 0
    }
    

    @IBAction func signUp(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if !isValidEmail(testStr: email) {
            showAlert(messgae: "Email Not Valid", messageCode: 1)
            return
        }
        if(isPasswordValid(password)){
           registerWithAws(email: email, password: password)
        }
    }
    
    private func registerWithAws(email : String, password : String) {
        let pool = AWSCognitoIdentityUserPool.init(forKey: "UserPool")
        //let emailAttribute = AWSCognitoIdentityUserAttributeType(name: "email", value: email)
        
        let poolTask = pool.signUp(email, password: password, userAttributes: [], validationData: nil)
        
        poolTask.continueWith { (task) -> Any? in
            if(task.error != nil) {
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: "error", message: "\(((task.error as NSError?)?.userInfo["message"])!)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                })
            }
            else{
                DispatchQueue.main.async(execute: {
                   self.dismissViewController(self)
                })
            }
            return nil
        }
        
    }
    

}
