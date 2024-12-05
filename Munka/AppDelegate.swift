//
//  AppDelegate.swift
//  Munka
//
//  Created by Amit on 08/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import UserNotifications
import IQKeyboardManagerSwift
import GoogleSignIn
import GoogleMaps
import GooglePlaces
//import Braintree
import Stripe
import LocalAuthentication

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,LocationServiceDelegate {
   
    //var apparrayProfileImage: [UIImage] = []
    var apparrayProfileImage = [UIImage]()
   // var appImageFileName: [String]()
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        if UserDefaults.standard.bool(forKey: "isAppLunch"){
            UserDefaults.standard.set(true, forKey: "isAppLunch")
            UserDefaults.standard.set(true, forKey: "isDisplayIntroPage")
            UserDefaults.standard.set(false, forKey: "isLogIn")
            
            UserDefaults.standard.synchronize()
        }
        registerForPushNotifications()
        
        
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
       // GIDSignIn.sharedInstance()?.uiDelegate = self 
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_KEY
        
        GMSServices.provideAPIKey(MAPKEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_APIKEY)
        MyDefaults().swifLoginType = "email"
       // MyDefaults().UDeviceToken = "123"
        MyDefaults().swiftFacebookData = nil
        MyDefaults().swiftGoolelData = nil
        MyDefaults().swiftReviewList.removeAll()
        MyDefaults().swiftDefaultViewProfile = nil
        
//        Stripe.setDefaultPublishableKey("pk_test_51HCXi0AWuQkXhibTxuuZIBlsZNx6xhB1YRQzsNP4ikG0wBcFOErXd6A252NtIunAxFlZOFLaWjy97YIoLUCKQ6QS00z1yIkEBo")
        Stripe.setDefaultPublishableKey("pk_live_51HCXi0AWuQkXhibTQhefTyBzY6b8rlDvgAZ2cShJxNnLBGuyjJbaFXEb3uNvdRR3AoUCvN7c3IiSwFWeMjRDzmE200gPxrzuvf")

      //  STPPaymentConfiguration.shared().publishableKey = STRIPE_APIKEY
        LocationSingleton.sharedInstance.delegate = self
        LocationSingleton.sharedInstance.startUpdatingLocation()
    
      /*  UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false*/
        
        if #available(iOS 13.0, *) {

            let newNavBarAppearance = customNavBarAppearance()
                    
                let appearance = UINavigationBar.appearance()
                appearance.scrollEdgeAppearance = newNavBarAppearance
                appearance.compactAppearance = newNavBarAppearance
                appearance.standardAppearance = newNavBarAppearance
                if #available(iOS 15.0, *) {
                    appearance.compactScrollEdgeAppearance = newNavBarAppearance
                }
        }
            
         SocketIOManager.socket.connect()
       // MyDefaults().UDeviceId! = "8A2496F0-EFD0-4723-8C6D-8E18431A49D2"
        
        //Live Credentials
        //Test creadential to check mass payment
       // PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: Key.PayPal.production])
         
        //PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: Key.PayPal.production,
        //PayPalEnvironmentSandbox: Key.PayPal.sandbox])
        //Braintree scheme
        //BTAppSwitch.setReturnURLScheme("com.hitashin.munka.payments")
        
        print("LoginStatus: \(MyDefaults().LoginStatus)")
        

        if UserDefaults.standard.bool(forKey: "isLogIn") {
            if MyDefaults().isBeiometicsAuthOn == true {
                self.authenticateUser()
            }else{
                let centerVC = storyBoard.tabbar.instantiateViewController(withIdentifier: "tabbar") as! MainTabbarVC
                centerVC.selectedIndex = 2
                window!.rootViewController = centerVC
                window!.makeKeyAndVisible()
            }
        }
        
        let center  = UNUserNotificationCenter.current()
               center.delegate = self
               // set the type as sound or badge
               if #available(iOS 12.0, *) {
                   center.requestAuthorization(options: [.sound,.alert,.badge,  .providesAppNotificationSettings]) { (granted, error) in
                       // Enable or disable features based on authorization
                   }
               } else {
                   // Fallback on earlier versions
               }
               application.registerForRemoteNotifications()
        
        return true
    }
    func authenticateUser() {
            let context = LAContext()
            var error: NSError?

            // Check if biometric authentication is available
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate to login" // Reason to show to the user for biometric authentication

                // Perform biometric authentication
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            // Biometric authentication succeeded
                            // Handle successful login
                            // For example, navigate to the main screen
                            print("Biometric authentication successful")
                            let centerVC = storyBoard.tabbar.instantiateViewController(withIdentifier: "tabbar") as! MainTabbarVC
                            centerVC.selectedIndex = 2
                            self.window!.rootViewController = centerVC
                            self.window!.makeKeyAndVisible()
                        } else {
                            // Biometric authentication failed or user chose to enter password
                            if let error = authenticationError as? LAError {
                                switch error.code {
                                case .userCancel:
                                    // User canceled biometric authentication
                                    print("User canceled biometric authentication")
                                case .biometryNotAvailable:
                                    // Biometric authentication not available on this device
                                    print("Biometric authentication not available")
                                case .biometryNotEnrolled:
                                    // Biometric authentication not enrolled on this device
                                    print("Biometric authentication not enrolled")
                                case .authenticationFailed:
                                    // Biometric authentication failed
                                    print("Biometric authentication failed")
                                default:
                                    // Other biometric authentication error
                                    print("Other biometric authentication error: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            } else {
                // Biometric authentication not available
                if let error = error {
                    let centerVC = storyBoard.tabbar.instantiateViewController(withIdentifier: "tabbar") as! MainTabbarVC
                    centerVC.selectedIndex = 2
                    window!.rootViewController = centerVC
                    window!.makeKeyAndVisible()
                    print("Biometric authentication not available: \(error.localizedDescription)")
                }
            }
        }

        
    @available(iOS 13.0, *)
    func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        // Apply a red background.
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor =  UIColor(red: 20/255.0, green: 76/255.0, blue: 222 / 255.0, alpha: 1)
        
        // Apply white colored normal and large titles.
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        // Apply white color to all the nav bar buttons.
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        return customNavBarAppearance
    }
       
    func tracingLocation(currentLocation: CLLocation) {
           // self.convertLatLongToAddress(latitude: currentLocation.coordinate.latitude, 
        }
        func tracingLocationDidFailWithError(error: NSError) {
            
        }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("Did ResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "MNMPinVC") as! MNMPinVC
//        let nav = UINavigationController(rootViewController: homeViewController)
//        nav.navigationBar.backgroundColor = .black
//        appdelegate.window!.rootViewController = nav
//        print("Did EnterBackground")
   
//        if MyDefaults().UserId != nil {
//          //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let initialViewController = storyBoard.Main.instantiateViewController(withIdentifier: "MNMPinVC")
//            // initialViewController.title = "mPin"
//            appDelegate().window?.rootViewController = initialViewController
//            appDelegate().window?.makeKeyAndVisible()
//
//                let loginVC = storyBoard.Main.instantiateViewController(withIdentifier: "MNMPinVC") as! MNMPinVC
//            let navigationVC = UINavigationController(rootViewController: loginVC)
//                  appDelegate().window!.rootViewController = navigationVC
        
        
//        }else{
//
//                    let loginVC = storyBoard.Main.instantiateViewController(withIdentifier: "MNLoginVC") as! MNLoginVC
//                    let navigationVC = UINavigationController(rootViewController: loginVC)
//                    appDelegate().window!.rootViewController = navigationVC
//
//        }
       
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("Did WillTerminate")
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
   //MARK:- Open URL Methods
        
        @available(iOS 9.0, *)
        func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
        {
         
         let returnFromFb = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
         
         let returnFromGmail = GIDSignIn.sharedInstance().handle(url)
          
         // let returnBraintry = BTAppSwitch.handleOpen(url, options: options)
         
         return  returnFromFb || returnFromGmail
         
         }
        //// For iOS 8 and earlier
        func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
         
         let returnFromFb = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
          
          let returnFromGmail = GIDSignIn.sharedInstance().handle(url)
          
         // let returnBraintry = BTAppSwitch.handleOpen(url)

          return  returnFromFb || returnFromGmail
      
        }
      
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
    
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
    }
    
    
    
  
    
}
extension AppDelegate {
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else {
                    print("Please enable \"Notifications\" from App Settings.")
                    self?.showPermissionAlert()
                    return
                }
                
                self?.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    //    {
    //        completionHandler([.alert, .badge, .sound])
    //    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        // UserDefaults.standard.set(token, forKey: DEVICE_TOKEN)
        MyDefaults().UDeviceId = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(title: "WARNING", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
            self?.gotoAppSettings()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func gotoAppSettings() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification
//        userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print(userInfo)
//        // print(userInfo)
//
//        let state = application.applicationState
//        switch state {
//
//        case .inactive:
//            print("Inactive")
//
//        case .background:
//            print("Background")
//            // update badge count here
//            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + MyDefaults().DefaultBadge
//
//        case .active:
//            print("Active")
//
//        }
//    }
   
    func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("Recived: \(userInfo)")
        
        completionHandler(.newData)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("userInfo:\(userInfo)")
       // let dictResponse =  userInfo as! [String : AnyObject]
        //let dictAlert = dictResponse["aps"] as! [String :AnyObject]

        // let responseData = userInfo["message_data"] as! [String: Any]
//        print(dictAlert["message_data"]!)
//        let badge = dictAlert["badge"] as! Int
//        print(badge)
//        var Totalbadge:Int = 0
//        let Pushbadge:Int! = Int(badge as! String)!
        
//        MyDefaults().DefaultBadge = badge
//        MyDefaults().DefaultBadge = MyDefaults().DefaultBadge + badge
//
//        print(MyDefaults().DefaultBadge)
//        MyDefaults().DefaultNotificationData = dictAlert as NSDictionary
//
////        let dict = userInfo["aps"]!
////        print(dict)
//        var rootVC : UIViewController?
//        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as! MainTabbarVC
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//       // rootVC?.ite
//        appDelegate.window?.rootViewController = rootVC
//        NotificationCenter.default.post(name: Notification.Name("didReceiveNotification"), object: badge)
       // NotificationCenter.default.post(Notification(name: Notification.Name("didReceiveNotification")))
    }

}
func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
