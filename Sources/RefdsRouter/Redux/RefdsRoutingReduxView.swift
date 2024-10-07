import SwiftUI
import RefdsRedux

public struct RefdsRoutingReduxView<
    Content: View,
    Destination: RefdsRoutableRedux,
    State: RefdsReduxState
>: View {
    @Binding private var router: RefdsRouterRedux<Destination, State>
    @Binding private var state: State
    private let action: (RefdsReduxAction) -> Void
    private let content: () -> Content
    
    public init(
        router: Binding<RefdsRouterRedux<Destination, State>>,
        state: Binding<State>,
        action: @escaping (RefdsReduxAction) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._router = router
        self._state = state
        self.action = action
        self.content = content
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: Destination.self) {
                    router.view(
                        for: $0,
                        state: $state,
                        action: action
                    )
                }
        }
        .sheet(item: $router.presentingSheet) {
            router.view(
                for: $0,
                state: $state,
                action: action
            )
        }
        .refdsFullScreenCover(item: $router.presentingFullScreenCover) {
            router.view(
                for: $0,
                state: $state,
                action: action
            )
        }
    }
}
