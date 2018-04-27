//
//  AppDelegate.swift
//  CMSC389L
//
//  Created by Jenish Kanani on 4/15/18.
//  Copyright © 2018 Jenish Kanani. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSUserPoolsSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    private let serviceCOnfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: nil)
    private let configuration = AWSCognitoIdentityUserPoolConfiguration(clientId: "66jfuc5gceim8g2sk39dd9m83b", clientSecret: "nt29e6ms6bor3d7elfpqpmaac5mgdvas7fsqkdltudi5n3ffd3b", poolId: "us-east-1_OYa3tk61h")
   
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      
        
        return AWSMobileClient.sharedInstance().interceptApplication(
            application, open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AWSCognitoIdentityUserPool.register(with: serviceCOnfiguration, userPoolConfiguration: configuration, forKey: "UserPool")
  
        return AWSMobileClient.sharedInstance().interceptApplication(
            application,
            didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

