import Flutter
import UIKit
import airbridge_flutter_sdk_restricted

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)
    AirbridgeFlutter.initializeSDK(name: "monkeystories", token: "4554eff61249472db3446ed1331312ef")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // when app is opened with scheme deeplink
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        // track deeplink
        AirbridgeFlutter.trackDeeplink(url: url)

        return true
    }

    // when app is opened with universal links
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        // track deeplink
        AirbridgeFlutter.trackDeeplink(userActivity: userActivity)

        return true
    }
}


