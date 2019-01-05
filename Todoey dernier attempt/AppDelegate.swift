//
//  AppDelegate.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 21/12/2018.
//  Copyright © 2018 BRUNO SMITH. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print out the path for our user defaults file and find the plist that stores our data, "entering the sandbox"
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // filling in a form and then they receive a call..
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // when app disappears off the screen, home button or open up another app.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // user triggered or system triggered : if resource intensive app it will reclaim some of the resources used by your app
    }


}

