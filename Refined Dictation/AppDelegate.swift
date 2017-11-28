//
//  AppDelegate.swift
//  Refined Dictation
//
//  Created by Admin on 30/10/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // initialize firebase settings
        FirebaseApp.configure()
        
        //initailze twitter kit
        Twitter.sharedInstance().start(withConsumerKey:"4noZ73JDhWGvcMGgOE2cLwY2j", consumerSecret:"VyBE0gBNE8ITGphqN6ahV3Vg1yv8w37QQ6aD8y2uiyLK3v9fYB")
        
        return true
    }
    
    // URL delegate to launch external google/fb login page
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication ?? "") ?? false
        
    }

}

