import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let image: String
    let description: String
    let sku: String
    let quantity: Int
}

struct ItemRow: View {
    
    var item: Item

    var body: some View {
        HStack(spacing: 40) {
            Text("\(item.name)")
            Spacer()
            Text("$\(item.price)")
            Spacer()
        }
    }
}

struct CommerceView: View {
    @StateObject var currentUser: CurrentUser
    
    let items = [
        Item(name: "Sun Block", price: 8, image: "🧴", description: "SPF 50...the best", sku: "sunBlk1", quantity: 1),
        Item(name: "Surf Board", price: 300, image: "🏄", description: "Kowabunga!", sku: "srfbrd1", quantity: 1),
        Item(name: "Swimming Trunks", price: 100, image: "🩳", description: "Make some waves in these tubular swim trunks", sku: "swmtrnk1", quantity: 1),
        Item(name: "Snorkel Gear", price: 5, image: "🤿", description: "Let the sea set you free", sku: "snork1", quantity: 1),
        Item(name: "Bikini", price: 12, image: "👙", description: "Life is better in a Bikini", sku: "bikini1", quantity: 1),
        Item(name: "Umbrella", price: 20, image: "🏖️", description: "Beach umbrellas are underrated", sku: "umbrl1", quantity: 1),
        Item(name: "Magic Conch Shell", price: 100, image: "🐚", description: "Am i cool?\n Magic Conch shell: Yes.", sku: "mgcnch1", quantity: 1),
        Item(name: "Sandals", price: 30, image: "🩴", description: "Don't be a shoebie", sku: "sndal1", quantity: 1)
    ]

    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(destination:
                    ItemDetail(item: item)) {
                    HStack(spacing: 40) {
                        Text(item.image)
                        
                        VStack(alignment: .leading) {
                            Text("\(item.name)")
                            Text("$\(item.price)")
                        }
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}
