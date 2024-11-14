//
//  AppDelegate.swift
//  ipass_plus
//
//  Created by MOBILE on 30/01/24.
//

import UIKit
import DocumentReader
import Amplify
import AWSCognitoAuthPlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let navigationController = application.windows[1].rootViewController as! UINavigationController
        do {
            Amplify.Logging.logLevel = .verbose
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
               try Amplify.configure()
           } catch {
               print("An error occurred setting up Amplify: \(error)")
           }
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
//          if let topController = window?.rootViewController?.topMostViewController() {
//              if topController is ViewController  {
//                  print("working in if")
//                  return .all
//              }
//              else  {
//                  print("working in else")
//                  return .all
//              }
//              // Add other view controllers and their orientations if needed
//          }
//        print("working in out")
//        return .all
//      
        
        if(UserLocalStore.shared.allowTransaction == true) {
            return .all
        }
        
        return .portrait
        
    
        
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

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? self
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}
