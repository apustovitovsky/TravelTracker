//
//  Created by Алексей on 18.11.2024.
//

import Foundation
import RouteComposer

// MARK: - PinEntryFactory

final class PasscodeModuleFactory: Factory {
    
    typealias ViewController = PasscodeViewController
    typealias Context = PasscodeModel
    
    func build(with context: PasscodeModel) throws -> PasscodeViewController {
        let presenter = PasscodeValidationPresenter(model: context, passcodeManager: PasscodeManager.shared)
        presenter.completion = { result in
            print(result)
        }
        let view = PasscodeView()
        let viewController = PasscodeViewController(presenter: presenter, customView: view)
        presenter.viewController = viewController
        return viewController
    }
}

