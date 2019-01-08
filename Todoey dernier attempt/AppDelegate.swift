//
//  AppDelegate.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 21/12/2018.
//  Copyright © 2018 BRUNO SMITH. All rights reserved.
//

import UIKit
import CoreData //coredata framework
import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Override point for customization after application launch.
        do {
            //realm is a new persistent container
            _ = try Realm() // means don't assign to anything

        } catch {
            print ("erroore")
        }
        return true
    }
}

