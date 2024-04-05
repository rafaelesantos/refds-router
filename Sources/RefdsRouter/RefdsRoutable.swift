import SwiftUI

public protocol RefdsRoutable: Hashable, Identifiable {
    associatedtype ViewType: View
    var navigationType: RefdsNavigationType { get }
    
    func view(router: RefdsRouter<Self>) -> ViewType
}

extension RefdsRoutable {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
