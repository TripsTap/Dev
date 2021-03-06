//
//  AppDelegate.swift
//  TripsTap
//
//  Created by Piyawut Kamwiset on 3/4/2558 BE.
//  Copyright (c) 2558 Piyawut Kamwiset. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // regis google map sdk
        GMSServices.provideAPIKey("AIzaSyDT_ZEA5Lp0TAPSY85VHEMECzbA_VK6xnQ")
        
        // regis facebook sdk
        FBLoginView.self
        
        //created slide menu
        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        let menuView = storyBoard.instantiateViewControllerWithIdentifier("MenuViewController")
        as! MenuViewController
       
        let nvc: UINavigationController = UINavigationController(rootViewController: mainView)
        menuView.mainViewController = nvc
        
        let slideMenuController = SlideMenuController(mainViewController: nvc , leftMenuViewController: menuView)
        slideMenuController.navigationController?.navigationBar.hidden = true
        
        
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        return true
    }

    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool{
            var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
            
            return wasHandled
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


}

