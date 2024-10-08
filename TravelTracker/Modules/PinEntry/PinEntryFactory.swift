//
//  Created by Алексей on 23.09.2024.
//

import Foundation
import RouteComposer

// MARK: - PinEntryFactory

final class PinEntryFactory: Factory {
    
    typealias ViewController = PinEntryViewController
    typealias Context = PinEntryModel
    
    func build(with context: PinEntryModel) throws -> PinEntryViewController {
        let viewModel = PinEntryViewModel(model: context, pinFlow: PinSetupFlow())
        let viewController = PinEntryViewController(viewModel: viewModel)
        viewModel.view = viewController
        return viewController
    }
}

