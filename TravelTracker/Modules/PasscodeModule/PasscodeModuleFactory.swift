//
//  Created by Алексей on 18.11.2024.
//

import Foundation
import RouteComposer


final class PasscodeModuleFactory: Factory {
    
    typealias ViewController = PasscodeViewController
    typealias Context = Any?
    
    func build(with context: Any?) throws -> PasscodeViewController {
        let model = PasscodeModel(length: 4)
        let presenter = PasscodeValidationPresenter(model: model, passcodeManager: PasscodeManager.shared)
        let view = PasscodeView()
        let viewController = PasscodeViewController(presenter: presenter, customView: view)
        presenter.viewController = viewController
        return viewController
    }
}


