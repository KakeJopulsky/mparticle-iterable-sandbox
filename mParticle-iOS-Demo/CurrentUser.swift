import SwiftUI

struct User: Codable {
    var id: String
    var email: String
    var username: String
    var acceptsNotifications: Bool
}

class CurrentUser: ObservableObject {
    var user: User
    
    // Retrieves or creates user information
    init() {
        if let savedUser = UserDefaults.standard.object(forKey: "UserData") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUser) {
                print(loadedUser.email)
                self.user = loadedUser
                return
            }
        }
        user = User(id: UUID().uuidString, email: "", username: "", acceptsNotifications: true)
        save()
    }
    
    var id: String {
        user.id
    }
    
    var email: String {
        get {
            user.email
        }
        set {
            user.email = newValue
        }
    }
    
    var username: String {
        get {
            user.username
        }
        set {
            user.username = newValue
        }
    }
    
    var acceptsNotifications: Bool {
        get {
            user.acceptsNotifications
        }
        set {
            user.acceptsNotifications = newValue
        }
    }
    
    // Save user information in UserDefaults
    func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(user) {
            UserDefaults.standard.set(data, forKey: "UserData")
        }
    }
}
