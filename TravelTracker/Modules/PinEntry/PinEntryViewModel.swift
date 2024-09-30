//
//  Created by Алексей on 23.09.2024.
//

import UIKit

//MARK: - HomeViewModelProtocol

protocol PinEntryViewModelProtocol: AnyObject {
    func viewDidLoad()
}

//MARK: - HomeViewModel

final class PinEntryViewModel {
    
    struct Dependencies {
        let pinManager: PinManagerProtocol
    }
    
    weak var view: PinEntryViewControllerProtocol?
    private var model: PinEntryModel
    private let dependencies: Dependencies
    
    init(model: PinEntryModel, dependencies: Dependencies) {
        self.model = model
        self.dependencies = dependencies
    }
}

extension PinEntryViewModel: PinEntryViewModelProtocol {
    
    func viewDidLoad() {
        model.title = dependencies.pinManager.prompt
        model.handler = { [weak self] action in
            self?.keypadButtonDidTap(action)
        }
        view?.configure(with: model)
    }
}


private extension PinEntryViewModel {
    
    
    func keypadButtonDidTap(_ action: PinEntryModel.Action) {
        switch action {
        case .add(let digit):
            guard model.enteredPinDigits.count < model.requiredPinLength else { return }
            
            model.previousPinDigits = model.enteredPinDigits
            model.enteredPinDigits.append(digit)
 
            if model.enteredPinDigits.count == model.requiredPinLength {
                let enteredPinCode = model.enteredPinDigits.map(String.init).joined()
                updateStateAndSetPin(with: enteredPinCode)
            }
            
        case .removeLast:
            if !model.enteredPinDigits.isEmpty {
                model.previousPinDigits = model.enteredPinDigits
                model.enteredPinDigits.removeLast()
            }
        }
        view?.configure(with: model)
    }
        
    func updateStateAndSetPin(with pinCode: String) {
        model.state = .reloading
        model.title = dependencies.pinManager.prompt
        model.enteredPinDigits.removeAll()
        model.buttons = model.buttons.map { button in
            var newButton = button
            newButton.state = .disabled
            return newButton
        }
            
        dependencies.pinManager.setPin(pinCode) { [weak self] _ in
            guard let self = self else { return }
            model.state = .normal
            model.title = dependencies.pinManager.prompt
            
            model.buttons = model.buttons.map { button in
                var newButton = button
                newButton.state = .normal
                return newButton
            }
            
            view?.configure(with: model)
        }
    }
}


