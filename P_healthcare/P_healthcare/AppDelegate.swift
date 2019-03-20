//
//  AppDelegate.swift
//  P_healthcare
//
//  Created by 佐藤優希 on 2018/12/17.
//  Copyright © 2018 佐藤優希. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var id:String? = nil
        var password:String? = nil
        let userDefaults = UserDefaults.standard
        if let idValue = userDefaults.string(forKey: "inputId"){
            id = idValue
        }
        if let passwordValue = userDefaults.string(forKey: "inputPassword"){
            password = passwordValue
        }
        if(id == nil || password == nil){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "initialView")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()

        }else{

        }
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {

            } else {
                let controller = UIAlertController(title: nil, message: "通知の設定が許可されていません。通知を許可したい場合は、設定アプリから通知の設定するか、本アプリから「通知設定」を押してください。", preferredStyle: UIAlertController.Style.alert)
                
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.window?.rootViewController?.present(controller, animated: true, completion: nil)
            }
        }

        return true
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
        print("open")
        //リフレッシュトークンを更新
        AuthPersonium().getUpdateRefreshToken()
        sleep(1)
        //Personiumに格納するヘルスケアデータを選択
        ReadStatus().authorizedStatus()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //Custom URL Scheme経由でアプリ開発が起動された場合
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AuthPersonium().startAuth(url: url)
        return true
    }
}

