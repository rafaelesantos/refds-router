import SwiftUI
import RefdsRedux

public struct RefdsRoutingReduxView<
    Content: View,
    State: RefdsReduxState,
    Destination: RefdsRoutableRedux
>: View {
    @Binding private var router: RefdsRouterRedux<Destination>
    @Binding private var store: RefdsReduxStore<State>
    private let content: () -> Content
    
    public init(
        router: Binding<RefdsRouterRedux<Destination>>,
        store: Binding<RefdsReduxStore<State>>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._router = router
        self._store = store
        self.content = content
    }
    
    private var bindingState: Binding<RefdsReduxState> {
        Binding {
            store.state
        } set: {
            guard let state = $0 as? State else { return }
            store.state = state
        }
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: Destination.self) {
                    router.view(
                        for: $0,
                        state: bindingState,
                        action: store.dispatch(action:)
                    )
                }
        }
        .sheet(item: $router.presentingSheet) {
            router.view(
                for: $0,
                state: bindingState,
                action: store.dispatch(action:)
            )
        }
        .refdsFullScreenCover(item: $router.presentingFullScreenCover) {
            router.view(
                for: $0,
                state: bindingState,
                action: store.dispatch(action:)
            )
        }
    }
}
