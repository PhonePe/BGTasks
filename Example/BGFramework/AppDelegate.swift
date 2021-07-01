//
//  AppDelegate.swift
//  BGFramework
//
//  Created by Shridhara V on 03/08/2021.
//  Copyright (c) 2021 Shridhara V. All rights reserved.
//

import UIKit
import BGFramework
import Foundation
import BackgroundTasks
import CommonCodeUtility

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var sync1: Sync1Handler?
    var sync2: Sync2Handler?

    var arraySyncs = [GenericSyncHandler]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if TestUtils.isRunningTest {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.tintColor = UIColor.purple
            
            self.window?.rootViewController = UIViewController()
            
            self.window?.makeKeyAndVisible()
            return true
        }
        
        let configuration = CommonConfiguration.Configuration(environment: .stage,
                                                              isDebugMode: true,
                                                              isSSLPinningEnabled: false,
                                                              isLogsEnabled: false,
                                                              isTestApp: true)
        CommonConfiguration.shared.set(configuration: configuration)
        
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.cancelAllTaskRequests()
            PPBGFramework.initialize()
        } else {
            // Fallback on earlier versions
        }
        
        self.sync1 = Sync1Handler()
        self.sync2 = Sync2Handler()
        
        for i in 3..<8 {
            arraySyncs.append(GenericSyncHandler(identifier: "id_\(i)", duration: TimeInterval(5), requiresNetworkConnectivity: true))
        }
        
//        for i in 8..<13 {
//            arraySyncs.append(GenericSyncHandler(identifier: "id_\(i)", duration: TimeInterval(5), requiresNetworkConnectivity: false))
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
