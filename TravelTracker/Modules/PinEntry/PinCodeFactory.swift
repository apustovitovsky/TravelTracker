//
//  Created by Алексей on 23.09.2024.
//

import Foundation
import RouteComposer

// MARK: - PinEntryFactory

final class PinCodeFactory: Factory {
    
    typealias ViewController = PinCodeViewController
    typealias Context = PinCodeModel
    
    func build(with context: PinCodeModel) throws -> PinCodeViewController {
        let viewModel = PinCodeViewModel(model: context, flow: PinCodeEntryFlow())
        viewModel.completion = { result in
            print("PinCode Module completed with \(result) result")
        }
        let viewController = PinCodeViewController(viewModel: viewModel)
        viewModel.view = viewController
        return viewController
    }
}

