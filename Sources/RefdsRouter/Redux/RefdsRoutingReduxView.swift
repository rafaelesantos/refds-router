import SwiftUI
import RefdsRedux

public struct RefdsRoutingReduxView<
    Content: View,
    State: RefdsReduxState,
    Destination: RefdsRoutableRedux
>: View {
    @Binding private var router: RefdsRouterRedux<Destination>
    @Binding private var state: State
    private let action: (RefdsReduxAction) -> Void
    private let content: () -> Content
    
    public init(
        router: Binding<RefdsRouterRedux<Destination>>,
        state: Binding<State>,
        action: @escaping (RefdsReduxAction) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._router = router
        self._state = state
        self.action = action
        self.content = content
    }
    
    private var bindingState: Binding<RefdsReduxState> {
        Binding { state } set: {
            guard let newState = $0 as? State else { return }
            state = newState
        }
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: Destination.self) {
                    router.view(
                        for: $0,
                        state: bindingState,
                        action: action
                    )
                }
        }
        .sheet(item: $router.presentingSheet) {
            router.view(
                for: $0,
                state: bindingState,
                action: action
            )
        }
        .refdsFullScreenCover(item: $router.presentingFullScreenCover) {
            router.view(
                for: $0,
                state: bindingState,
                action: action
            )
        }
    }
}
