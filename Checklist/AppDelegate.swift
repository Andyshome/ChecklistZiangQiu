

import UIKit
import UserNotifications
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var Delegate = delegate()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
        if granted {
            application.registerForRemoteNotifications()
        } else {
            print("User Notification permision denied : \(error?.localizedDescription)")
        }
        
    }
    // Override point for customization after application launch.
    
    
    // 3D touch delegate
    let addDelegateIcon = UIApplicationShortcutIcon.init(type: .add)
    let addDelegateItem = UIApplicationShortcutItem.init(type: "delegate", localizedTitle: "AddDelegate", localizedSubtitle: "", icon: addDelegateIcon, userInfo: nil)
    
    UIApplication.shared.shortcutItems = [addDelegateItem]
    
    
    
    
    
    return true
  }
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let tabBarVC = window?.rootViewController as? ViewController else {
            print("error")
            return
        }
        
        switch shortcutItem.type {
        case "delegate":
            let addDelegateController = AddDelegateViewController()
            addDelegateController.hidesBottomBarWhenPushed = true
            print("try to get there")
            tabBarVC.presentingViewController?.children.first?.present(addDelegateController, animated: true, completion: nil)
        default:
            break
            
        }
    }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    Delegate.saveData()
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    Delegate.saveData()
    }


}

