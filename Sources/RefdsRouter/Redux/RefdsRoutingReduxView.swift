import SwiftUI
import RefdsRedux

public struct RefdsRoutingReduxView<
    Content: View,
    Destination: RefdsRoutableRedux
>: View {
    @Binding private var router: RefdsRouterRedux<Destination>
    @Binding private var store: RefdsReduxStore<RefdsReduxState>
    private let content: () -> Content
    
    public init(
        router: Binding<RefdsRouterRedux<Destination>>,
        store: Binding<RefdsReduxStore<RefdsReduxState>>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._router = router
        self._store = store
        self.content = content
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            content()
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
