import SwiftUI

struct OrderView: View {
    @EnvironmentObject var order: Order
    @StateObject var currentUser: CurrentUser
    
    var totalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let total = Double(order.total)
        return formatter.string(from: NSNumber(value: total)) ?? "$0"
    }
    
    func placeOrder() {
        MParticleManager.trackPurchase(order: order)
    }
    
    func clearCart() {
        order.clearCart()
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(order.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }
                    }
                }
                Section(header: Text("TOTAL: \(totalPrice)")) {
                    Button ("Place Order") {
                        placeOrder()
                    }
                    Button("Clear cart") {
                        clearCart()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Order")
            .listStyle(InsetGroupedListStyle())
        }
    }
}
