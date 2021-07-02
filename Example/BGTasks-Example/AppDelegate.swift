//
//  AppDelegate.swift
//  BGTasks-Example
//
//  Created by Shridhara V on 02/07/21.
//

import UIKit
import BGTasks
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if TestUtils.isRunningTest {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.tintColor = UIColor.purple
            
            self.window?.rootViewController = UIViewController()
            
            self.window?.makeKeyAndVisible()
            return true
        }
        
        if #available(iOS 13.0, *) {
            let permittedIdentifiers: [BGTaskSchedulerType: String] = [
                .appRefreshTask: "com.bg.tasks.example.app.refresh.task",
                .processingTaskWithConnectivityWithExternalPower: "com.bg.tasks.example.processing.task.with.connectivity.with.power",
                .processingTaskWithConnectivityWithoutExternalPower: "com.bg.tasks.example.processing.task.with.connectivity.no.power",
                .processingTaskWithoutConnectivity: "com.bg.tasks.example.processing.task.no.connectivity"
            ]
            
            let config = BGConfigurationProvider.RegistrationData(permittedIdentifiers: permittedIdentifiers)
            BGConfigurationProvider.shared.configure(config: config)
        }
        
        return true
    }
    
    func initialize() {
        
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
