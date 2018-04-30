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
    private var shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar()
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
    
    private var isUploading = false
    @IBAction func makeMagicHappen(_ sender: Any) {
        if(!isUploading){
            uploadData()
        }
    }
    
    func uploadData() {
        if let data = UIImagePNGRepresentation(photoView.image!) {
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, progress) in
                DispatchQueue.main.async(execute: {
                    self.shapeLayer.strokeEnd = CGFloat(progress.fractionCompleted)
                   
                })
            }
        
            let completionHandler : AWSS3TransferUtilityUploadCompletionHandlerBlock?  =
            {(task, error) in
                if let error = error {
                    
                }else{
                    DispatchQueue.main.async(execute: {
                        self.isUploading = false;
                        self.photoView.isHidden = false
                        self.shapeLayer.isHidden = true
                        self.shapeLayer.strokeEnd = 0
                    })
                }
            }
        
            let transferUtility = AWSS3TransferUtility.default()
        
            transferUtility.uploadData(data, bucket: "cmsc389l-jkanani1", key: "image1", contentType: "image/png", expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                if let error = task.error {
                    print(error)
                }else{
                    DispatchQueue.main.async {
                        self.isUploading = true;
                        self.photoView.isHidden = true
                        self.shapeLayer.isHidden = false
                    }
                }
                return nil
            }
            
          
        }
    }
    
    func progressBar() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
       
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 10
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        shapeLayer.isHidden = true
    }
    
    
}
