//
//  AppDelegate.swift
//  Monami
//
//  Created by abc on 20/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import RealmSwift
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,GIDSignInDelegate , GIDSignInUIDelegate{
    var window: UIWindow?
   // let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // sleep(3)
        let simulaterToken = "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        UserDefaults.standard.set(simulaterToken as String, forKey: "devicetoken")
        registerForRemoteNotification()
        //TODO : Implenting IQKeyboard
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        checkAutoLogin()
        checkForLanguage()
        if   ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        {
            return true
        }
        else {
            GIDSignIn.sharedInstance().clientID = "783849982224-ab7naavpnlpt9eqq4spuaci5d3cbna4i.apps.googleusercontent.com"
            GIDSignIn.sharedInstance().delegate = self
            return true
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if ApplicationDelegate.shared.application(app,open: url as URL!,sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation] as Any){
            return true
        }else if GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation]){
            return true
        }
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "STOPAUDIOPLAYER"), object:nil, userInfo: nil)
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "STOPAUDIOPLAYER"), object:nil, userInfo: nil)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    //MARK:- DEVICE TOKEN GET HERE
    //MARK:
    
    
    func registerForRemoteNotification() {
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    
                    DispatchQueue.main.async {
                        
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        UserDefaults.standard.set(deviceTokenString as String, forKey: "devicetoken")
        
        NSLog("Device Token : %@", deviceTokenString)
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        let simulaterToken = "Simulatorb1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        UserDefaults.standard.set(simulaterToken, forKey: "devicetoken")
        print(error, terminator: "")
        
        
    }
    
    
    func checkAutoLogin()
    {
        let realm = try! Realm()
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            if userInfo.type == ""{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                vc.selectedIndex = 3
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            }else if userInfo.type == "parent"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            
        }
    }
    
    //MARK:- Langauge change
    
    func checkForLanguage() {
        let selectLanguage = UserDefaults.standard.value(forKey: "Language") as? String ?? ""
        
        if selectLanguage == "English" {
            Localize.setCurrentLanguage(language: "en")
            Bundle.setLanguage("en")
            UserDefaults.standard.set("English", forKey: "Language")
        }
        else {
            Localize.setCurrentLanguage(language: "pt-PT")
            Bundle.setLanguage("pt-PT")
            UserDefaults.standard.set("Portuguese", forKey: "Language")
        }
    }
    
    //MARK: - Google signIn Delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print("error\(error.localizedDescription)")
        }else{
            guard let name = user.profile.name
                else {return}
            guard let idToken = user.authentication.idToken
                else {return}
            guard let accessToken = user.authentication.accessToken
                else {return}
            print("Successfully loggedIn")
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,withError error: Error!) {
        
        if error != nil{
            print("error\(error.localizedDescription)")
        }else{
            guard let name = user.profile.name
                else {return}
            guard let idToken = user.authentication.idToken
                else {return}
            guard let accessToken = user.authentication.accessToken
                else {return}
            print("Successfully loggedIn")
        }
    }
    
    //MARK:  UNNOTIFICATION DELGATE METHODS
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void){
        print("in will present")
        let screen_name  =  ScreeNNameClass.shareScreenInstance.screenName
        if let userInfo = notification.request.content.userInfo as? NSDictionary{
            if let apsDict = userInfo.value(forKey: "aps") as? NSDictionary{
                guard let badgeCount = apsDict.value(forKey: "badge") as? Int else{
                    print("No badgeCount")
                    return
                }

                if let alertDict = apsDict.value(forKey: "alert") as? NSDictionary{
                    if screen_name == "HomeVC"{
                        if let type = alertDict.value(forKey: "type") as? String{
                            if type == "PAV"{
                                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HOMENOTIFYRELOAD"), object:nil, userInfo: nil)
                            }else{
                                completionHandler([.alert, .badge, .sound])
                            }
                    }
                    }else if screen_name == "CommentsVC"{
                        if let type = alertDict.value(forKey: "type") as? String{
                            if type == "comment"{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "COMMENTNOTIFYRELOAD"), object:nil, userInfo: nil)
                            }else{
                                completionHandler([.alert, .badge, .sound])
                            }
                        }
                    }
                    else if screen_name == "ReportsVC"{
                        if let type = alertDict.value(forKey: "type") as? String{
                            if type == "report"{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "REPORTNOTIFYRELOAD"), object:nil, userInfo: nil)
                            }else{
                                completionHandler([.alert, .badge, .sound])
                            }
                        }
                    }else if screen_name == "ChatListVC" || screen_name == "ChatVC"{
                        if let type = alertDict.value(forKey: "type") as? String{
                            if type == "chat"{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHATNOTIFYRELOAD"), object:nil, userInfo: nil)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHATLISTNOTIFYRELOAD"), object:nil, userInfo: nil)
                            }else if screen_name == "ManageFamilyVC"{
                                if let type = alertDict.value(forKey: "type") as? String{
                                    if type == "follow"{
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MANAGENOTIFYRELOAD"), object:nil, userInfo: nil)
                                    }else{
                                        completionHandler([.alert, .badge, .sound])
                                    }
                                }
                            }else{
                                completionHandler([.alert, .badge, .sound])
                            }
                        }
                    }else if screen_name == "NotificationVC"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NOTIFICATIONLISTNOTIFYRELOAD"), object:nil, userInfo: nil)
                    }else{
                        completionHandler([.alert, .badge, .sound])
                    }
            }
        }
    }
}
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        print("in did recieve")
        if let userInfo = response.notification.request.content.userInfo as? NSDictionary{
            print(userInfo)
            let realm = try! Realm()
            if let userInfo1 = realm.objects(SignUpDataModel.self).first{
                
                if let apsDict = userInfo.value(forKey: "aps") as? NSDictionary{
                    guard let badgeCount = apsDict.value(forKey: "badge") as? Int else{
                        print("No badgeCount")
                        return
                    }
                    if let alertDict = apsDict.value(forKey: "alert") as? NSDictionary{
                        if let thread_id = apsDict.value(forKey: "thread_id") as? Int{
                        self.decreaseBadgeCountApi(thread_id, alertDict, apsDict)
                        
                    }
                    }
                }
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            }
        }
    }
    
}

//MARK: - Extension web services implementations

extension AppDelegate{
    
    //TODO: Decrease badge count api
    func decreaseBadgeCountApi(_ thread_id : Int, _ alertDict : NSDictionary, _ apsDict : NSDictionary){
        if InternetConnection.internetshared.isConnectedToNetwork(){
           // macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("notify_count/\(thread_id)", success: { (responseJASON) in
               // self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    if let responseDict = responseJASON["response"].dictionaryObject as? NSDictionary{
                        guard let badge = responseDict.value(forKey: "badge") as? Int else{
                            print("No badge")
                            return
                        }
                        UIApplication.shared.applicationIconBadgeNumber = badge
                    
                    if let type = alertDict.value(forKey: "type") as? String{
                        if type == "PAV"{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let destinationController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
                            let navController = UINavigationController(rootViewController: destinationController!)
                            navController.navigationBar.isHidden = true
                            self.window!.rootViewController = navController
                        }else if type == "comment"{
                            guard let batchDict = apsDict.value(forKey: "batch") as? NSDictionary else{
                                print("No batch")
                                return
                            }
                            
                            guard let post_id = batchDict.value(forKey: "post_id") as? String else{
                                print("No post_id")
                                return
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let destinationController = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as? CommentsVC
                            destinationController?.isComing = "NOTI"
                            destinationController?.post_id = post_id
                            let navController = UINavigationController(rootViewController: destinationController!)
                            navController.navigationBar.isHidden = true
                            self.window!.rootViewController = navController
                            
                            
                        } else if type == "report"{
                            
                            guard let batchDict = apsDict.value(forKey: "batch") as? NSDictionary else{
                                print("No batch")
                                return
                            }
                            
                            guard let child_id = batchDict.value(forKey: "child_id") as? Int else{
                                print("No child_id")
                                return
                            }
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let destinationController = storyboard.instantiateViewController(withIdentifier: "ReportsVC") as? ReportsVC
                            destinationController?.isComing = "NOTI"
                            destinationController?.children_id = String(child_id)
                            let navController = UINavigationController(rootViewController: destinationController!)
                            navController.navigationBar.isHidden = true
                            self.window!.rootViewController = navController
                        }else if type == "follow"{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let destinationController = storyboard.instantiateViewController(withIdentifier: "ManageFamilyVC") as? ManageFamilyVC
                            destinationController?.isComing = "NOTI"
                            let navController = UINavigationController(rootViewController: destinationController!)
                            navController.navigationBar.isHidden = true
                            self.window!.rootViewController = navController
                            
                        }else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                            let nav = UINavigationController(rootViewController: vc)
                            nav.isNavigationBarHidden = true
                            vc.selectedIndex = 1
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
                        }
                    }
                }
                }else{
                   // self.macroObj.hideLoader(view: self.view)
//                    if let message = responseJASON["message"].string as? String{
//                        _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.error)
//                    }
                    
                }
                
                
            }, failure: { (error) in
                //self.macroObj.hideLoader(view: self.view)
                print(error.localizedDescription)
              //  _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.ErrorMessage.rawValue, style: AlertStyle.error)
            })
            
        }else{
           // self.macroObj.hideLoader(view: self.view)
          //  _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.NoInternet.rawValue, style: AlertStyle.error)
        }
    }
}
