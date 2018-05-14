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
    
    enum Method {
        case ocr
        case celeb
    }
    
    private var shapeLayer = CAShapeLayer()
    private var shapeLayer2 = CAShapeLayer()
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var smallPictureView: UIImageView!
    

    @IBOutlet weak var smallImageViewHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var smallImageViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var smallImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var smallImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var bigImageViewConstraints: [NSLayoutConstraint]!
    private var newTempConstraints : [NSLayoutConstraint] = []
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var menuViewTopConstraint: NSLayoutConstraint!
    
    private var mt : Method = .ocr
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar()
        smallPictureView.layer.cornerRadius = smallPictureView.frame.size.width/2
        smallPictureView.clipsToBounds = true
        
        tempConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func tempConstraints(){
        let height = NSLayoutConstraint(item: self.photoView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.smallImageViewHeightConstraint.constant)
        let width = NSLayoutConstraint(item: self.photoView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.smallImageViewWidthConstraint.constant)
        let centerHorizontal = NSLayoutConstraint(item: self.photoView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let centerVertical = NSLayoutConstraint(item: self.photoView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        newTempConstraints.append(height)
        newTempConstraints.append(width)
        newTempConstraints.append(centerHorizontal)
        newTempConstraints.append(centerVertical)
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
        if(photoView.image == nil) {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.isUploading = true;
            
            NSLayoutConstraint.deactivate(self.bigImageViewConstraints)
            NSLayoutConstraint.activate(self.newTempConstraints)
        
            self.photoView.layer.cornerRadius = self.smallPictureView.frame.size.width/2
            self.photoView.clipsToBounds = true
         
            self.view.layoutIfNeeded()
        })
        {
            (_) in
            self.percentageLabel.text = "0%"
            
            UIView.animate(withDuration: 0.5, animations: {
                self.shapeLayer.isHidden = false
                self.shapeLayer2.isHidden = false
                self.percentageLabel.isHidden = false
            })
            {
                (_) in
                if let data = UIImagePNGRepresentation(self.photoView.image!) {
                    let expression = AWSS3TransferUtilityUploadExpression()
                    expression.progressBlock = {
                        (task, progress) in
                        DispatchQueue.main.async(execute: {
                            self.shapeLayer.strokeEnd = CGFloat(progress.fractionCompleted)
                            let completed = Int(progress.fractionCompleted*100)
                            self.percentageLabel.text = "\(completed)" + "%"
                        })
                    }
                    let completionHandler : AWSS3TransferUtilityUploadCompletionHandlerBlock?  =
                    {
                        (task, error) in
                        if let err = error {
                            print(err)
                        }
                        else{
                            DispatchQueue.main.async(execute: {
                                
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.isUploading = false;
                          
                                    self.shapeLayer.isHidden = true
                                    self.shapeLayer2.isHidden = true
                                    self.percentageLabel.isHidden = true

                                    self.photoView.layer.cornerRadius = 0
                                    
                                    self.shapeLayer.strokeEnd = 0
                                    
                                    NSLayoutConstraint.deactivate(self.newTempConstraints)
                                    NSLayoutConstraint.activate(self.bigImageViewConstraints)
                                    
                                    self.view.layoutIfNeeded()
                                    
                                    self.performSegue(withIdentifier: "celebs", sender: nil)
                                })
   
                            })
                        }
                    }
                    let transferUtility = AWSS3TransferUtility.default()
                    transferUtility.uploadData(data, bucket: "cmsc389l-jkanani1", key: "image1", contentType: "image/png", expression: expression, completionHandler: completionHandler).continueWith {
                        (task) -> Any? in
                        if let error = task.error {
                            print(error)
                        }
                        else{
                        }
                        return nil
                    }
                }
            }
        }
    }
    
    func progressBar() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: smallPictureView.frame.size.width/2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 5
        shapeLayer.strokeEnd = 0
        
        let color = UIColor(red: 255/255, green: 105/255, blue: 122/255, alpha: 1)
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer2.path = circularPath.cgPath
        shapeLayer2.lineWidth = 5
        shapeLayer2.strokeColor = UIColor.lightGray.cgColor
        shapeLayer2.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(shapeLayer2)
        view.layer.addSublayer(shapeLayer)
        
        self.shapeLayer.isHidden = true
        self.shapeLayer2.isHidden = true
        self.percentageLabel.isHidden = true
        
        smallPictureView.isHidden = true
    }
    
    @IBAction func dropDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            if(self.visualEffectView.alpha == 0) {
                self.visualEffectView.alpha = 1
                self.view.bringSubview(toFront: self.menuView)
                self.view.bringSubview(toFront: sender)
                self.menuViewTopConstraint.constant = 15
                self.view.layoutIfNeeded()
                
            }else{
                self.visualEffectView.alpha = 0
                self.menuViewTopConstraint.constant = -200
                self.view.layoutIfNeeded()
            }
            
        }
    
    }
    
    func createButton() -> UIButton {
        let button = UIButton();
        button.setTitle("Find a Celibrity", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
        
    }
    
    @IBAction func methodOfReckon(_ sender: UIButton) {
        if sender.titleLabel?.text == "OCR" {
            mt = .ocr
        }
        else{
            mt = .celeb
        }
    }
}



