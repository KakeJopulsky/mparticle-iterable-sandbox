import SwiftUI

struct ProfileView: View {
    
    @StateObject var currentUser: CurrentUser
    @State var email = ""
    @State var username = ""
    @State var isEditMode = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {

                Spacer()
                if isEditMode {
                    Button("Cancel") {
                        isEditMode.toggle()
                    }
                } else {
                    Button("Edit") {
                        isEditMode.toggle()
                    }
                }
            }.padding()
            if !isEditMode {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("User Profile")
                            .bold()
                            .font(.title)

                        Text("Email: \(currentUser.email)")
                        Text("Username: \(currentUser.username)")
                        Text("Notifications: \(currentUser.acceptsNotifications ? "On": "Off" )")
                        Text("UserId: \(currentUser.id)")
                            .font(.system(size: 12))
                    }
                    .padding()
                }
            } else {
                List {
                    HStack {
                        Text("Email").bold()
                        Divider()
                        TextField("Email", text: $email)
                            .disableAutocorrection(true)
                    }
                    
                    HStack {
                        Text("Username").bold()
                        Divider()
                        TextField("Username", text: $username)
                            .disableAutocorrection(true)
                    }

                    Toggle(isOn: $currentUser.acceptsNotifications) {
                        Text("Enable Notifications").bold()
                    }
                    
                    HStack {
                        Spacer()
                        Button ("Save") {
                            if (currentUser.email != email) {
                                currentUser.email = email
                                MParticleManager.modifyIdentity(currentUser: currentUser)
                            }
                            if (currentUser.username != username) {
                                currentUser.username = username
                                MParticleManager.setUserAttributes(currentUser: currentUser, key: "username", value: currentUser.username)
                            }
                            MParticleManager.logEvent(currentUser: currentUser, eventName: "Profile Updated", customAttributes: [:])
                            currentUser.save()
                            isEditMode.toggle()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @StateObject static var currentUser = CurrentUser()
    static var previews: some View {
        ProfileView(currentUser: currentUser)
    }
}
