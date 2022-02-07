import SwiftUI
import mParticle_Apple_SDK

@main
struct mParticle_iOS_DemoApp: App {
    @StateObject var order = Order()
    
    @UIApplicationDelegateAdaptor()
    private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(currentUser: appDelegate.currentUser)
                .environmentObject(order)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    let currentUser = CurrentUser()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MParticleManager.initialize(currentUser: currentUser)
        print ("Current user ID: \(currentUser.id)")
        setupNotifications()
        return true
    }
    
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("😀 device token: \(token)")
        MParticleManager.register(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MParticleManager.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register token: \(error.localizedDescription)")
        MParticle.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//      guard let url = userActivity.webpageURL else {
//        return false
//      }
//        return true
//    }
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                // not authorized, ask for permission
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
                    if success {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    } else {
                        print ("Push notifications denied")
                    }
                    // TODO: Handle error etc.
                }
            } else {
                // already authorized
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        MParticleManager.userNotificationCenter(center, willPresent: notification)
        completionHandler([.banner, .badge, .sound])
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MParticleManager.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
}
