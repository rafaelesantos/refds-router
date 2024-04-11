import SwiftUI

public class RefdsRouter<Destination: RefdsRoutable>: ObservableObject {
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var presentingSheet: Destination?
    @Published public var presentingFullScreenCover: Destination?
    @Published public var isPresented: Binding<Destination?>
    
    public var isPresenting: Bool {
        presentingSheet != nil || presentingFullScreenCover != nil
    }
    
    public init(isPresented: Binding<Destination?>) {
        self.isPresented = isPresented
    }
    
    @ViewBuilder 
    public func view(for route: Destination) -> some View {
        let router = router(type: route.navigationType)
        route.view(router: router)
    }
    
    public func route(to destination: Destination) {
        switch destination.navigationType {
        case .push: push(destination)
        case .sheet: presentSheet(destination)
        case .fullScreenCover: presentFullScreen(destination)
        }
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    public func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        } else if presentingSheet != nil {
            presentingSheet = nil
        } else if presentingFullScreenCover != nil {
            presentingFullScreenCover = nil
        } else {
            isPresented.wrappedValue = nil
        }
    }
    
    private func push(_ appRoute: Destination) {
        path.append(appRoute)
    }
    
    private func presentSheet(_ route: Destination) {
        self.presentingSheet = route
    }
    
    private func presentFullScreen(_ route: Destination) {
        self.presentingFullScreenCover = route
    }
    
    private func router(type: RefdsNavigationType) -> RefdsRouter {
        switch type {
        case .push:
            return self
        case .sheet:
            return RefdsRouter(
                isPresented: Binding(
                    get: { self.presentingSheet },
                    set: { self.presentingSheet = $0 }
                )
            )
        case .fullScreenCover:
            return RefdsRouter(
                isPresented: Binding(
                    get: { self.presentingFullScreenCover },
                    set: { self.presentingFullScreenCover = $0 }
                )
            )
        }
    }
}
