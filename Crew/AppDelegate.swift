//
//  AppDelegate.swift
//  Crew
//
//  Created by Rajeev on 22/02/21.
//

import UIKit
import CoreData
import AWSS3
import AWSCore
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var window: UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            Bundle.setLanguage("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UserDefaults.standard.setValue("ar", forKey: "Language")
        }else{
            Bundle.setLanguage("en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaults.standard.setValue("en", forKey: "Language")
        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // keyboard handler
        IQKeyboardManager.shared.enable = true
        
        //Firebase
        registerForPushNotifications(application: application)
        
        self.appSettings()
        
        //Update user details
        UserDetailsCrud().fetchProfiles(completion: { profileDetails in
            Profile.shared.details = profileDetails
        })
        
       
        
        
        //Delaying one second to let awake the app to post NSNotification
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //checking saved push notifications
            if let dataDict = UserDefaults.standard.value(forKey: "PushNotification") as? [AnyHashable : Any]{
                NotificationCenter.default.post(name: Notification.notification, object: nil, userInfo: dataDict)
                UserDefaults.standard.removeObject(forKey: "PushNotification")
            }
        }
        
        let doneBarButtonConfig = IQBarButtonItemConfiguration(title: NSLocalizedString("Done", comment: ""), action: nil)
        IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBarButtonConfig

        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("deep link1")
        var handler:Bool = false
        if url.scheme?.caseInsensitiveCompare(Url.scheme) == .orderedSame {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil, userInfo: nil)
            handler = true
        }
        return handler
    }
   
    internal func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Get URL components from the incoming user activity
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return false
        }
        
//        let pathComponents = incomingURL.absoluteString.components(separatedBy: "/")
        
        if incomingURL.absoluteString.contains("crew-sa.com"){
            let pathComponents = incomingURL.absoluteString.components(separatedBy: "/")
            for component in pathComponents{
                if Int(component) != nil{
                    NotificationCenter.default.post(name: Notification.deepLink, object: nil, userInfo: ["id":component])
                }
            }
        }
        
        if let dataDict = UserDefaults.standard.value(forKey: "PushNotification") as? [AnyHashable : Any]{
            NotificationCenter.default.post(name: Notification.notification, object: nil, userInfo: dataDict)
            UserDefaults.standard.removeObject(forKey: "PushNotification")
        }
        
        print("deeep link2")

        return true
    }
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        //        print("noti rec \(userInfo)")
        //        print("bright---- \(UIScreen.main.brightness)")
        
        
        if UIApplication.shared.applicationState == .active && UIScreen.main.brightness>0.0{
            NotificationCenter.default.post(name: Notification.notification, object: nil, userInfo: nil)
        }
        
        let localNotification = UNMutableNotificationContent()
        localNotification.sound = UNNotificationSound.default
        localNotification.userInfo = userInfo
        
        debugPrint(userInfo)
        
        if (UIApplication.shared.applicationState != .inactive) {
            
            if let notifyJsonString = userInfo["extraData"]{
                
                if let jsonData = (notifyJsonString as! String).data(using: String.Encoding.utf8){
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? NSDictionary
                        {
                            print(jsonDict) // use the json here
                            
                            localNotification.body = (jsonDict["description"] as? String ?? "")
                            localNotification.title = (jsonDict["title"] as? String ?? "")
                            
                            let notifyType = (jsonDict["notify_type"] as? String ?? "")
                            let notifyId = String(jsonDict["value"] as? Int ?? 0)
                            let dataDict:[String: String] = ["type": notifyType,"id":notifyId]
                            
                            //checking if app is in foreground and device is not locked
                            if UIApplication.shared.applicationState == .active && UIScreen.main.brightness>0.0{
                                NotificationCenter.default.post(name: Notification.notification, object: nil, userInfo: dataDict)
                            }else{
                                UserDefaults.standard.set(dataDict, forKey: "PushNotification")
                            }
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                            let request = UNNotificationRequest(identifier: "TempPush", content: localNotification, trigger: trigger)
                            let center = UNUserNotificationCenter.current()
                            center.add(request, withCompletionHandler: { error in
                            })
                            
                            completionHandler(UIBackgroundFetchResult.newData)
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
            }
        }
        
        
    }
    
    
    
    
    //MARK : App settings api for CDN Details
    func appSettings(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
        ]
        
        WebServices.postRequest(url: Url.appInternalSettings, params: parameters, viewController: UIViewController()) { success,data  in
            do {
                let decoder = JSONDecoder()
                let awsResponse = try decoder.decode(AppSettings.self, from: data)
                
                DispatchQueue.main.async {
                    
                    if success{
                        
                        UserDefaults.standard.setValue(awsResponse.data.AWS_ACCESS_KEY_ID, forKey: AWS.AWS_ACCESS_KEY_ID)
                        UserDefaults.standard.setValue(awsResponse.data.AWS_SECRET_ACCESS_KEY, forKey: AWS.AWS_SECRET_ACCESS_KEY)
                        UserDefaults.standard.setValue(awsResponse.data.AWS_BUCKET, forKey: AWS.AWS_BUCKET)
                        UserDefaults.standard.setValue(awsResponse.data.AWS_URL, forKey: AWS.AWS_URL)
                        
                        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: awsResponse.data.AWS_ACCESS_KEY_ID!, secretKey: awsResponse.data.AWS_SECRET_ACCESS_KEY!)
                        let configuration = AWSServiceConfiguration.init(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
                        AWSServiceManager.default().defaultServiceConfiguration = configuration
                        
                    }else{
                        Banner().displayValidationError(string: NSLocalizedString("Invalid input", comment: ""))
                    }
                }
                
            } catch let error {
                
                Banner().displayValidationError(string: NSLocalizedString("\(error)", comment: ""))
                print("\(error.localizedDescription)")
                print(error)
            }
        }
        
    }
    
    
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "ddMMyyyy"
        randomString =  dateFormatter.string(from: Date()) + randomString
        
        return randomString
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        UserDefaults.standard.setValue(fcmToken, forKey: FCM.token)
        self.updateFCMToken()
    }
    func updateFCMToken(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "fcm_id" : UserDefaults.standard.value(forKey: FCM.token) ?? ""
        ]
        
        WebServices.postRequest(url: Url.updateFCMToken, params: parameters, viewController: UIViewController()) { success,data  in
            
            DispatchQueue.main.async {
                
                if success{
                    print("fcm token updated succesfully")
                }else{
                    print("fcm token failed to update")
                }
            }
            
        }
        
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        Messaging.messaging().apnsToken = deviceToken
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("this will return '32 bytes' in iOS 13+ rather than the token \(tokenString)")
    }
    
    
    func registerForPushNotifications(application: UIApplication) {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
            if (granted)
            {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            else{
                //Do stuff if unsuccessful...
            }
        })
        
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Crew" )
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

