 //
//  OCRViewController.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 5/11/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAPIGateway
import AWSMobileClient
import AWSLambda

struct Celebs {
    var name : String
    var link : URL?
}
class OCRViewController : ViewController, UITableViewDelegate, UITableViewDataSource, TableViewMoreInfoDelegate {
    var celebrities = [Celebs]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invokeLambda(imageName: "")
    
        
    }
    func invokeLambda(imageName: String) {
        let httpMethodName = "POST"
        let URLString = "/path-416"
        let queryStringParameters = ["key1" : "value1"]
        let headerParameters = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let httpBody = "{ \n  " +
            "\"key1\":\"\(imageName)\", \n  " +
            "\"key2\":\"value2\", \n  " +
        "\"key3\":\"value3\"\n}"
        
        let apiRequest = AWSAPIGatewayRequest(httpMethod: httpMethodName, urlString: URLString, queryParameters: queryStringParameters, headerParameters: headerParameters, httpBody: httpBody)
        let serviceConfig = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: AWSMobileClient.sharedInstance().getCredentialsProvider())
        
        AWSAPI_0FZV066R46_JenishMobileHubClient.register(with: serviceConfig!, forKey: "CloudLogicAPIKey")
        let invocationClient = AWSAPI_0FZV066R46_JenishMobileHubClient(forKey: "CloudLogicAPIKey")
        
        invocationClient.invoke(apiRequest).continueWith { (task) -> Any? in
            if let error = task.error{
                print("Error occured: \(error)")
                return nil
            }

            DispatchQueue.main.async(execute: {
                let result = task.result?.responseData
                let json = try? JSONSerialization.jsonObject(with: result!, options: []) as! NSDictionary
                let value = json!.value(forKey: "CelebrityFaces") as! NSArray
                
                for k in value {
                    if let k = k as? NSDictionary {
                        let name = k.value(forKey: "Name") as! String
                        let url = (k.value(forKey: "Urls") as! NSArray)
                        let link = ""
                        if let link = url[0] as? String {
                            
                            let newLink =  "https://" + link
                         
                            self.celebrities.append(Celebs(name: name, link: URL(string: newLink)))
                        }else{
                            self.celebrities.append(Celebs(name: name, link: URL(string: link)))
                        }
                       
                    }
                }
                
                self.tableView.reloadData()
            })

            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        let celeb = celebrities[indexPath.row]
        cell.name.text = celeb.name
        cell.url = celeb.link
        cell.delegate = self
        return cell
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell).frame.height
    }
    
    func openWebView(url: URL) {
        print(UIApplication.shared.canOpenURL(url))
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.openURL(url)
        }
    }
    
}
class CustomCell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    var url : URL?
    var indexpath: IndexPath?
    var delegate : TableViewMoreInfoDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    @IBAction func viewMoreInfo(_ sender: UIButton) {
        if let url = url{
            if let delegate = delegate {
                delegate.openWebView(url: url)
            }
        }
    }
    
}
 
 protocol TableViewMoreInfoDelegate {
    func openWebView(url: URL)
 }
