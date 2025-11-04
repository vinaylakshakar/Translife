//
//  AppDelegate.swift
//  transLife
//
//  Created by Developer Silstone on 30/11/18.
//  Copyright © 2018 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import IQKeyboardManagerSwift
import SVProgressHUD
import FirebaseInstanceID
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
static var DEVICEID = String()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {granted, error in
                    if granted{
                         print("notification Request authorization succeeded!")
                    }else{
                       print("Request authorization failed!")
                    }
            })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        if UserDefaults.standard.value(forKey: "device_token") != nil{
            if UserDefaults.standard.value(forKey:"device_token") as! String == ""{
                refreshTokenNow()
            }
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 20
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        
        SVProgressHUD.setForegroundColor(hexStringToUIColor(hex: "#52DBFB"))           //Ring Color
      //  SVProgressHUD.setBackgroundLayerColor(UIColor(red: 255, green: 157, blue: 0, alpha: 1))    //Background Color
        if Auth.auth().currentUser != nil{
            if UserDefaults.standard.value(forKey: "username") != nil{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
                appDelegate.window?.rootViewController = ViewController
           
            }else{
                        //signout if username is nil
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                SVProgressHUD.dismiss()
                            } catch let signOutError as NSError {
                      //  self.PresentAlert(message: signOutError.localizedDescription, title: "TransLife")
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let loginView = storyboard.instantiateViewController(withIdentifier: "RootNav")
                            UIApplication.shared.keyWindow?.rootViewController = loginView
            }
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginView = storyboard.instantiateViewController(withIdentifier: "RootNav")
            UIApplication.shared.keyWindow?.rootViewController = loginView
        }

        //Offline persistance
        Database.database().isPersistenceEnabled = false
        
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if application.applicationState == .active {
            print("active")
            //app is currently active, can update badges count here
        } else if application.applicationState == .background {
             print("background")
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
        } else if application.applicationState == .inactive {
             print("inactive")
         
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
        }
    }
  
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "notification.id.01" {
            print("handling notifications with the TestIdentifier Identifier")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
           // let navVC = UINavigationController()
            appDelegate.window?.rootViewController = ViewController
            
        }else if response.notification.request.content.body == "New Survey added by admin" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
            appDelegate.window?.rootViewController = ViewController
        }else if response.notification.request.content.body == "New event added by admin" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
            appDelegate.window?.rootViewController = ViewController
        }
        print(response.notification.request.content.userInfo)
        
        completionHandler()
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        print("deviceToken: \(deviceTokenString)" )
        
        UserDefaults.standard.set(deviceTokenString, forKey: "device_token")
        UserDefaults.standard.synchronize()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
              print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
               
                
               // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
                AppDelegate.DEVICEID = fcmToken
            }
        }
        print("Firebase registration token: \(fcmToken)")
        FcmToken = fcmToken
        UserDefaults.standard.set(fcmToken, forKey: "fcm_token")
        UserDefaults.standard.synchronize()
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
       // print("Handle push from foreground")
        // custom code to handle push while app is in the foreground
        if notification.request.content.body == "New event added by admin" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarController")
            appDelegate.window?.rootViewController = ViewController
            
        }
        print("\(notification.request.content.userInfo)")
        completionHandler([.alert, .badge, .sound])
    }
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Messaging.messaging().shouldEstablishDirectChannel = false
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
    @objc func refreshToken(notification: NSNotification) {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching device token: \(error)")
            } else if let result = result {
                print("*** \(result.token) ***")
                UserDefaults.standard.set(result.token, forKey: "fcm_token")
                UserDefaults.standard.synchronize()
                AppDelegate.DEVICEID = result.token
            }
        }
    }
    func refreshTokenNow() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching device token: \(error)")
            } else if let result = result {
                print("*** \(result.token) ***")
                UserDefaults.standard.set(result.token, forKey: "fcm_token")
                 UserDefaults.standard.synchronize()
                AppDelegate.DEVICEID = result.token
            }
        }
    }
    
}

