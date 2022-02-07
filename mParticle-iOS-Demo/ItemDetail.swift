import SwiftUI

struct ItemDetail: View {
    @EnvironmentObject var order: Order
    let item: Item
    
    var body: some View {
        VStack {
            ZStack {
                Text(item.image).font(.system(size: 84))
            }
            Text(item.description)
                .padding()
            Button("Order This") {
                order.add(item: item)
            }
            .font(.headline)
            Spacer()
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
