import SwiftUI
import RefdsRedux

public protocol RefdsRoutable: Hashable, Identifiable {
    associatedtype ViewType: View
    var navigationType: RefdsNavigationType { get }
    
    func view(router: RefdsRouter<Self>) -> ViewType
    func view(
        router: RefdsRouter<Self>,
        state: Binding<RefdsReduxState>,
        action: (RefdsReduxAction) -> Void
    ) -> ViewType
}

extension RefdsRoutable {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
