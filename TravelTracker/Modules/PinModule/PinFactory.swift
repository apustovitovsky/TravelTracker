import Foundation
import RouteComposer

// MARK: - Pin Factory

class PinFactory: Factory {
    
    typealias ViewController = PinViewController
    typealias Context = Void
    private let configuration: ((_: ViewController) -> Void)?
    
    init(configuration: ((_: ViewController) -> Void)? = nil) {
        self.configuration = configuration
    }
    
    func build(with _: Void) throws -> PinViewController {
        let pinManager = PinCodeCheckManager(keychainManager: KeychainManager())
        let presenter = PinPresenter(pinManager: pinManager)
        let viewController = PinViewController(presenter: presenter)
        presenter.view = viewController
        
        if let configuration {
            configuration(viewController)
        }
        
        return viewController
    }
}
