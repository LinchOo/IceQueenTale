import UIKit
import AppTrackingTransparency
import AppsFlyerLib
import AdSupport
import FBSDKCoreKit
import FirebaseCore
import FirebaseAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    var timeZoneAbbreviationLocal: String {
        return TimeZone.current.abbreviation() ?? ""
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    func timeZoneCurrent() -> String {
        return TimeZone.current.identifier
    }

    let codeLanguageLocalized = NSLocale.current.languageCode

    var oldAndNotWorkingNames: [String : Any] = [:]
    var dataAttribution: [String : Any] = [:]
    var deepLinkParameterFB: String = ""
    var uniqueIdentifierAppsFlyer: String = ""

    var identifierAdvertising: String = ""
    var tokenPushNotification: String = ""

    let StartUp = StartApp()
    let pushNotificationJoo = JooPush()
    
    var subject1 = ""
    var subject2 = ""
    var subject3 = ""
    var subject4 = ""
    var subject5 = ""
    var oneLinkDeepLink = ""

    var geographicalNameTimeZone: String = ""
    var abbreviationTimeZone: String = ""
    var applicationLocalized: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        geographicalNameTimeZone = timeZoneCurrent()
        abbreviationTimeZone = timeZoneAbbreviationLocal
        applicationLocalized = codeLanguageLocalized ?? ""
        pushNotificationJoo.notificationCenter.delegate = pushNotificationJoo
        pushNotificationJoo.requestAutorization()
        AppsFlyerLib.shared().appsFlyerDevKey = "LbSAnvCDRqtFBTGvL9i8dV"
        AppsFlyerLib.shared().appleAppID = "6463804150"
        AppsFlyerLib.shared().deepLinkDelegate = self
        AppsFlyerLib.shared().delegate = self
        uniqueIdentifierAppsFlyer = AppsFlyerLib.shared().getAppsFlyerUID()

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        self.createFacebook()
        self.createGoogleFirebase()

        return true
    }
    func createFacebook() {
        AppLinkUtility.fetchDeferredAppLink { (url, error) in
            if let error = error {
            }
            if let url = url {
                self.deepLinkParameterFB = url.absoluteString
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    func createGoogleFirebase() {
        FirebaseApp.configure()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        if #available(iOS 14, *) {
            AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .authorized:
                   
                    self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    Settings.shared.isAdvertiserTrackingEnabled = true
                case .denied:
                    print("Denied")
                    self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                case .notDetermined:
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }

                DispatchQueue.main.async {
                    if let rootViewController = self.window?.rootViewController as? StartApp {
                        rootViewController.modalPresentationStyle = .fullScreen
                        rootViewController.startToRequest()
                    }
                }
            }
        } else {
            self.identifierAdvertising = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        AppsFlyerLib.shared().start()
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)

        return true

    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

        AppsFlyerLib.shared().handleOpen(url, options: options)
        return true

    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        let token = tokenParts.joined()
        
        tokenPushNotification = token
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        
    }
    func applicationWillTerminate(_ application: UIApplication) {
        DispatchQueue.main.async {
            (self.window!.rootViewController as? Helper)?.jooLastUrl()
            
        }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        DispatchQueue.main.async {
            (self.window!.rootViewController as? Helper)?.jooLastUrl()
           
        }
    }
}
extension AppDelegate: AppsFlyerLibDelegate{
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        oldAndNotWorkingNames = installData as! [String : Any]
        for (key, value) in installData {
            print(key, ":", value)
        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("////////////////////////////////////////////////////////This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)////////////////////////////////////////////////////////")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
               is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }

    //MARK: onConversionDataFail
    func onConversionDataFail(_ error: Error) {
        print(error)
    }

    //MARK: onAppOpenAttribution
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        self.dataAttribution = attributionData as! [String : Any]
        print("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            print(key, ":",value)
        }
    }

    //MARK: onAppOpenAttributionFailure
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
}
extension AppDelegate: DeepLinkDelegate {
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .notFound:
            NSLog("////////////////////////////////////////////////////////[AFSDK] Deep link not found////////////////////////////////////////////////////////")
            return
        case .failure:
            print("Error %@", result.error!)
            return
        case .found:
            NSLog("[AFSDK] Deep link found")
        }

        guard let deepLinkObj:DeepLink = result.deepLink else {
            NSLog("[AFSDK] Could not extract deep link object")
            return
        }
        let subjectKeys = ["deep_link_sub1", "deep_link_sub2", "deep_link_sub3", "deep_link_sub4", "deep_link_sub5"]

        for key in subjectKeys {
            if let referrerId = deepLinkObj.clickEvent[key] as? String {
                NSLog("[AFSDK] AppsFlyer: Referrer ID: \(referrerId)")
                switch key {
                case "deep_link_sub1":
                    self.subject1 = referrerId
                case "deep_link_sub2":
                    self.subject2 = referrerId
                case "deep_link_sub3":
                    self.subject3 = referrerId
                case "deep_link_sub4":
                    self.subject4 = referrerId
                case "deep_link_sub5":
                    self.subject5 = referrerId
                default:
                    break
                }
            } else {
                NSLog("[AFSDK] Could not extract referrerId")
            }
        }
        
        let deepLinkStr:String = deepLinkObj.toString()
        NSLog("[AFSDK] DeepLink data is: \(deepLinkStr)")
        self.oneLinkDeepLink = deepLinkStr
        if deepLinkObj.isDeferred {
            NSLog("[AFSDK] This is a deferred deep link")
        } else {
            NSLog("[AFSDK] This is a direct deep link")
        }
    }
}

