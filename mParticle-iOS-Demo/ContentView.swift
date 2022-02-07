import SwiftUI
import Network

struct ContentView: View {
    @StateObject var currentUser: CurrentUser
    @State private var isLoggedIn = false
    @State private var isStarted = false
    @State private var isAnonymous = false
    @State private var showingSheet = false
    @State private var email = ""
    @State var labelWidth: CGFloat? = nil
    @State var username = ""
    @State var password = ""
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    // Grid of event options
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        if !isStarted {
            Button("Get Started") {
                if !currentUser.email.isEmpty {
                    isLoggedIn = true
                }
                isStarted = true
            }
        } else {
            if !isLoggedIn {
                VStack {
                    UserImage()
                    HStack {
                        TextField("Email", text: $email)
                            .padding()
                            .background(lightGreyColor)
                            .cornerRadius(5.0)
                            .disableAutocorrection(true)
                        Button(action: {
                            currentUser.email = email
                            if !currentUser.email.isEmpty {
                                currentUser.save()
                                isLoggedIn.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle")
                                Text("Login")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(5.0)
                        }
                    }.padding(.bottom, 50).padding(.leading, 10).padding(.trailing, 10)
                    Button(action: {
                        isAnonymous.toggle()
                        isLoggedIn.toggle()
                    } ) {
                        HStack {
                            Image(systemName: "eye.slash")
                            Text("Continue anonymously")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(.infinity)
                    }
                }
            } else {
                TabView {
                    ProfileView(currentUser: currentUser)
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                    CommerceView(currentUser: currentUser)
                        .tabItem {
                            Label("Menu", systemImage: "list.dash")
                        }
                    OrderView(currentUser: currentUser)
                        .tabItem {
                            Label("Order", systemImage: "square.and.pencil")
                        }
                }
                .onAppear { MParticleManager.login(currentUser: currentUser) }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    @StateObject static var currentUser = CurrentUser()
    static var previews: some View {
        ContentView(currentUser: currentUser)
    }
}

struct UserImage : View {
    var body : some View {
        return Image("hmmmm")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
    }
}



