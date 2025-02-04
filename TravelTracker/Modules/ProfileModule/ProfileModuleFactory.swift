//
//  Created by Алексей on 18.11.2024.
//

import Foundation
import RouteComposer

final class ProfileModuleFactory: Factory {
    
    typealias ViewController = ProfileViewController
    typealias Context = Any?
    
    func build(with context: Any?) throws -> ProfileViewController {
        let presenter = ProfilePresenter()

        let view = PasscodeView()
        let viewController = ProfileViewController(presenter: presenter, customView: view)
        return viewController
    }
}
