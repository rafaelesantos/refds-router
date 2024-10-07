import SwiftUI
import RefdsRedux

@preconcurrency
public struct RefdsReduxRoutingView<
    Content: View,
    Destination: RefdsRoutableRedux,
    State: RefdsReduxState
>: View {
    @Binding var router: RefdsRouterRedux<Destination, State>
    @Binding var store: RefdsReduxStore<State>
    private let content: (RefdsRouterRedux<Destination, State>) -> Content
    
    public init(
        router: Binding<RefdsRouterRedux<Destination, State>>,
        store: Binding<RefdsReduxStore<State>>,
        @ViewBuilder content: @escaping (RefdsRouterRedux<Destination, State>) -> Content
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
