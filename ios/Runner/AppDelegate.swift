import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import FirebaseCore
import FBSDKCoreKit
// import FirebaseFirestore
// import FirebaseAuth
// import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
//    GeneratedPluginRegistrant.register(with: self)

    ApplicationDelegate.shared.application(
    application,
    didFinishLaunchingWithOptions: launchOptions
    )
    GeneratedPluginRegistrant.register(with: self)

    return true
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
    } else {
        let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      }
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   override func application(
           _ app: UIApplication,
           open url: URL,
           options: [UIApplication.OpenURLOptionsKey : Any] = [:]
       ) -> Bool {
           ApplicationDelegate.shared.application(
               app,
               open: url,
               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
               annotation: options[UIApplication.OpenURLOptionsKey.annotation]
           )
       }
}
