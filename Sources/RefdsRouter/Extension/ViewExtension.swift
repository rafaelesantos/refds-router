import SwiftUI

public extension View {
    func refdsFullScreenCover<Item, Content>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View where Item : Identifiable, Content : View {
        ZStack {
            self
            if let item = item.wrappedValue {
                content(item)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

