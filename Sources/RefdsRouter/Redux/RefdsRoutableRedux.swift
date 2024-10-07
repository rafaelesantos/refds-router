import SwiftUI
import RefdsRedux

public protocol RefdsRoutableRedux: Hashable, Identifiable, Sendable {
    associatedtype ViewType: View
    var navigationType: RefdsNavigationType { get }
    
    func view<State: RefdsReduxState>(
        router: RefdsRouterRedux<Self, State>,
        state: Binding<State>,
        action: (RefdsReduxAction) async -> Void
    ) -> ViewType
}

extension RefdsRoutableRedux {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
