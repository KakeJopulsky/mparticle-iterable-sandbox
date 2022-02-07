import Foundation

class Order: ObservableObject {
    @Published var items = [Item]()

    var total: Int {
        if items.count > 0 {
            return items.reduce(0) { $0 + $1.price }
        } else {
            return 0
        }
    }

    func add(item: Item) {
        items.append(item)
        MParticleManager.updateCart(items: items)
    }
    
    func clearCart() {
        items = []
        MParticleManager.updateCart(items: items)
    }
}
