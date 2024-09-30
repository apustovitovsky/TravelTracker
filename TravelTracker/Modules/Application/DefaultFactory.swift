import Foundation
import RouteComposer

// MARK: - DefaultFactory

class DefaultFactory: Factory {
    
    typealias ViewController = DefaultVC
    typealias Context = ScreenDefinition
    
    private let configuration: Handler<DefaultVC>?
    
    init(configuration: Handler<DefaultVC>? = nil) {
        self.configuration = configuration
    }
    
    func build(with context: ScreenDefinition) throws -> DefaultVC {
        let viewController = DefaultVC(context: context)

        if let configuration {
            configuration(viewController)
        }
        
        return viewController
    }
}


