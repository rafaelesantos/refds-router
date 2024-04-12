import SwiftUI
import RefdsRedux

public struct RefdsRoutingView<
    Content: View,
    Destination: RefdsRoutable
>: View {
    @Binding var router: RefdsRouter<Destination>
    private let content: (RefdsRouter<Destination>) -> Content
    
    public init(
        router: Binding<RefdsRouter<Destination>>,
        @ViewBuilder content: @escaping (RefdsRouter<Destination>) -> Content
    ) {
        self._router = router
        self.content = content
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            content(router)
                .navigationDestination(for: Destination.self) { router.view(for: $0) }
        }
        .sheet(item: $router.presentingSheet) { router.view(for: $0) }
        .refdsFullScreenCover(item: $router.presentingFullScreenCover) { router.view(for: $0) }
    }
}

public struct RefdsReduxRoutingView<
    Content: View,
    Destination: RefdsRoutable
>: View {
    @Binding var router: RefdsRouter<Destination>
    @Binding var store: RefdsReduxStore<RefdsReduxState>
    private let content: (RefdsRouter<Destination>) -> Content
    
    public init(
        router: Binding<RefdsRouter<Destination>>,
        store: Binding<RefdsReduxStore<RefdsReduxState>>,
        @ViewBuilder content: @escaping (RefdsRouter<Destination>) -> Content
    ) {
        self._router = router
        self._store = store
        self.content = content
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            content(router)
                .navigationDestination(for: Destination.self) {
                    router.view(
                        for: $0,
                        state: $store.state,
                        action: store.dispatch(action:)
                    )
                }
        }
        .sheet(item: $router.presentingSheet) { 
            router.view(
                for: $0,
                state: $store.state,
                action: store.dispatch(action:)
            )
        }
        .refdsFullScreenCover(item: $router.presentingFullScreenCover) { 
            router.view(
                for: $0,
                state: $store.state,
                action: store.dispatch(action:)
            )
        }
    }
}

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
