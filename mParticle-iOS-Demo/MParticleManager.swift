import Foundation
import SwiftUI
import mParticle_Apple_SDK
import IterableSDK
import mParticle_Iterable

class MParticleManager {
    private static let mParticleKey = "<MPARTICLE_KEY>"
    private static let mParticleSecret = "<API_SECRET>"
    
    public static let shared = MParticleManager()
    var currentUser: CurrentUser?
    
    static func initialize(currentUser: CurrentUser) {
        MParticleManager.shared.currentUser = currentUser
        let mParticleOptions = MParticleOptions(
            key: mParticleKey,
            secret: mParticleSecret
        )
        mParticleOptions.proxyAppDelegate = false
        mParticleOptions.logLevel = .debug;
        mParticleOptions.environment = .development
        
        // Iterable configuration
        let itblConfig = IterableConfig()
        itblConfig.pushIntegrationName = "jakekopulsky.mParticle-iOS-Demo"
        itblConfig.sandboxPushIntegrationName = "jakekopulsky.mParticle-iOS-Demo"
        MPKitIterable.setCustomConfig(itblConfig)
        
        MParticle.sharedInstance().start(with: mParticleOptions)
    }
    
    static func didReceiveRemoteNotification(userInfo: [AnyHashable : Any]) {
        MParticle.sharedInstance().didReceiveRemoteNotification(userInfo)
    }
    
    // Identity request callback
    static func identityCallback(result: MPIdentityApiResult?, error: Error?) {
        if (result?.user != nil) {
            // Do something once an identity call has been made.
            // result?.user.setUserAttribute("example attribute key2", value: "example attribute value3")
        } else {
            NSLog(error!.localizedDescription)
            let resultCode = MPIdentityErrorResponseCode(rawValue: UInt((error! as NSError).code))
            switch (resultCode!) {
            case .clientNoConnection,
                 .clientSideTimeout:
                //retry the IDSync request
                break;
            case .requestInProgress,
                 .retry:
                //inspect your implementation if this occurs frequency
                //otherwise retry the IDSync request
                break;
            default:
                // inspect error.localizedDescription to determine why the request failed
                // this typically means an implementation issue
                break;
            }
        }
    }
    
    // Login a user with customerId and email (if available)
    // This would trigger an updateEmail call
    static func login(currentUser: CurrentUser) {
        let identityRequest = MPIdentityApiRequest()
        if (currentUser.email.isEmpty) {
            print ("✨ Email not identified. Setting customer ID: \(currentUser.id)")
            identityRequest.customerId = currentUser.id
            MParticle.sharedInstance().identity.login(identityRequest, completion: identityCallback)
        } else {
            print ("✨ Email found. Setting email \(currentUser.email) and customer ID: \(currentUser.id)")
            identityRequest.email = currentUser.email
            identityRequest.customerId = currentUser.id
            MParticle.sharedInstance().identity.login(identityRequest, completion: identityCallback)
        }
    }
    
    // Add, remove, or change the identities associated with an existing user
    static func modifyIdentity(currentUser: CurrentUser) {
        let identityRequest = MPIdentityApiRequest()
        identityRequest.email = currentUser.email
        identityRequest.customerId = currentUser.id
        MParticle.sharedInstance().identity.modify(identityRequest, completion: identityCallback)
        print ("✨ Updating user identity")
    }
    
    // Sets user attributes on the currentUser's identity
    static func setUserAttributes(currentUser: CurrentUser, key: String, value: String) {
        let currentUser = MParticle.sharedInstance().identity.currentUser
        currentUser?.setUserAttribute(key, value: value)
    }
    
    // Logs a custom event
    static func logEvent(currentUser: CurrentUser, eventName: String, customAttributes: [String: Any]) -> Void {
        if let event = MPEvent(name: eventName, type: MPEventType.userContent) {
            event.customAttributes = customAttributes
            MParticle.sharedInstance().logEvent(event)
        }
    }
    
    static func updateCart(items: [Item]) -> Void {
        var products: [MPProduct] = []
        for item in items {
            let product = MPProduct.init(
                name: item.name,
                sku: item.sku,
                quantity: item.quantity as NSNumber,
                price: item.price as NSNumber)
            products.append(product)
        }
        
        let action = MPCommerceEventAction.addToCart;
        let event = MPCommerceEvent.init(action: action)
        event?.addProducts(products)
        MParticle.sharedInstance().logEvent(event!)
        print ("✨ Tracking cart update")
    }
    
    static func trackPurchase(order: Order) -> Void {
        if (order.items.count < 1) {
            return
        }
        var items: [MPProduct] = []
        for item in order.items {
            let product = MPProduct.init(
                name: item.name,
                sku: item.sku,
                quantity: item.quantity as NSNumber,
                price: item.price as NSNumber)
            items.append(product)
        }
        
        // Add products
        let action = MPCommerceEventAction.purchase;
        let event = MPCommerceEvent.init(action: action)
        event?.addProducts(items)
        
        // Add transaction attributes
        let attributes = MPTransactionAttributes.init()
        attributes.transactionId = UUID().uuidString
        attributes.revenue = order.total as NSNumber
        
        // Add custom attributes (where Iterable campaign and template ID are mapped from)
        let customAttributes: [String: Any] = [
            "campaignId": "12345",
            "templateId": "54321"
        ]
        event?.customAttributes = customAttributes
        
        MParticle.sharedInstance().logEvent(event!)
        print ("✨ Tracking purchase event")
    }
    
    
    
    class func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) {
        MParticle.sharedInstance().userNotificationCenter(center, willPresent: notification)
    }
    
    class func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MParticle.sharedInstance().userNotificationCenter(center, didReceive: response)
    }
    
    static func didReceiveRemoteNotification(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        MParticle.sharedInstance().didReceiveRemoteNotification(userInfo)
    }
    
    static func register(deviceToken: Data) {
        print ("registeringa")
        print (MParticle.sharedInstance().identity.getAllUsers()[0].userId)
        MParticle.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
}
