import SwiftUI
import RefdsRedux

public struct RefdsRoutingReduxView<
    Content: View,
    Destination: RefdsRoutableRedux
>: View {
    @Binding private var router: RefdsRouterRedux<Destination>
    @EnvironmentObject private var store: RefdsReduxStore<Destination.State>
    private let content: () -> Content
    
    public init(
        router: Binding<RefdsRouterRedux<Destination>>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._router = router
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
