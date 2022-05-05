//
//  AppDelegate.swift
//  Adopby
//
//  Created by Hatto on 16/3/2565 BE.
//

import UIKit
import Firebase
import DropDown
import CometChatPro

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let appId = "2085240fbdc167bf"
    let region = "eu"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = UIColor.init(rgb: 0xF7D154)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        
        let mySettings = AppSettings.AppSettingsBuilder().subscribePresenceForAllUsers().setRegion(region:   region).build()
        CometChat(appId: appId ,appSettings: mySettings,onSuccess: { (isSuccess) in
            print("CometChat Pro SDK intialise successfully.")
        }) { (error) in
            print("CometChat Pro SDK failed intialise with error: \(error.errorDescription)")
        }
        
        FirebaseApp.configure()
        DropDown.startListeningToKeyboard()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

