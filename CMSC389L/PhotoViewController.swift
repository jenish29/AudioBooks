//
//  PhotoViewController.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 4/16/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit
import AWSS3

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBAction func snapPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeMagicHappen(_ sender: Any) {
        uploadData()
    }
    
    func uploadData() {
        let data = UIImagePNGRepresentation(photoView.image!) as! Data
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                print("came here")
            })
        }
        
        let completionHandler : AWSS3TransferUtilityUploadCompletionHandlerBlock?  =
        {(task, error) in
            DispatchQueue.main.async(execute: {
                print("error = " ,error)
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(data, bucket: "cmsc389l-jkanani1", key: "image1", contentType: "image/png", expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print(error)
            }else{
                print(task.result)
            }
            
            return nil
        }
        
    
    }
    
    
}
