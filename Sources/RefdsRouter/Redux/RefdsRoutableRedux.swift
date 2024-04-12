import SwiftUI
import RefdsRedux

public protocol RefdsRoutableRedux: Hashable, Identifiable {
    associatedtype ViewType: View
    var navigationType: RefdsNavigationType { get }
    
    func view(
        router: RefdsRouterRedux<Self>,
        state: Binding<RefdsReduxState>,
        action: @escaping (RefdsReduxAction) -> Void
    ) -> ViewType
}

extension RefdsRoutableRedux {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
