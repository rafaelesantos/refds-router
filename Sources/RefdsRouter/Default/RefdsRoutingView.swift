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
