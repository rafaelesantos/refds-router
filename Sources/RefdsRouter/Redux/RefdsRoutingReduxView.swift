import SwiftUI
import RefdsRedux

public struct RefdsRoutingReduxView<
    Content: View,
    Destination: RefdsRoutableRedux
>: View {
    @Binding var router: RefdsRouterRedux<Destination>
    @Binding var store: RefdsReduxStore<Destination.State>
    private let content: (RefdsRouterRedux<Destination>) -> Content
    
    public init(
        router: Binding<RefdsRouterRedux<Destination>>,
        store: Binding<RefdsReduxStore<Destination.State>>,
        @ViewBuilder content: @escaping (RefdsRouterRedux<Destination>) -> Content
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