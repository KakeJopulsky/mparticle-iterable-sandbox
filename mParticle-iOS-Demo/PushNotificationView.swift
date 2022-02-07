import SwiftUI

struct PushNotificationView: View {
    @StateObject var currentUser: CurrentUser
    
    func triggerPush() -> Void {
        MParticleManager.logEvent(currentUser: currentUser, eventName: "mParticleKit-triggered-push", customAttributes: ["source": "mParticleKit demo app"])
    }
    
    func triggerInApp() -> Void {
        MParticleManager.logEvent(currentUser: currentUser, eventName: "mParticleKit-triggered-inapp", customAttributes: ["source": "mParticleKit demo app"])
    }
    
    var body: some View {
        Text("Push notification view")
//            .onAppear { MParticleManager.logEvent(currentUser: currentUser, eventName: "Screen View", customAttributes: ["Screen": "Push"]) }
            .onAppear { triggerInApp() }
    }
}

//struct PushNotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        PushNotificationView()
//    }
//}
