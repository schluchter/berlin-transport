//
//  AppDelegate.swift
//  berlin-transport
//
//  Created by Thomas Schluchter on 9/15/14.
//  Copyright (c) 2014 Thomas Schluchter. All rights reserved.
//

import UIKit
import Realm
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        AFNetworkActivityLogger.sharedLogger().level = .AFLoggerLevelDebug
        AFNetworkActivityLogger.sharedLogger().startLogging()
        
        self.setUpPersistentData()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setUpPersistentData() {
        let realm = RLMRealm.defaultRealm()
        let path = NSBundle.mainBundle().pathForResource("stops", ofType: "txt")!
        
        let stop1 = GTFSStop()
        stop1.name = "Anne-Frank-Str. (Berlin)"
        stop1.id = "9195506"
        stop1.lat = 52.4091540
        stop1.long = 13.5344170
        
        let stop2 = GTFSStop()
        stop2.name = "U Pankstr. (Berlin)"
        stop2.id = "9195506"
        stop2.lat = 52.5522550
        stop2.long = 13.3818370
        
        realm.beginWriteTransaction()
        realm.addObject(stop1)
        realm.addObject(stop2)
        realm.commitWriteTransaction()
        
    }
    
}

