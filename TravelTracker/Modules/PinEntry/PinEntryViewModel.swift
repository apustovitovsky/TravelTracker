//
//  Created by Алексей on 23.09.2024.
//

import UIKit

//MARK: - PinEntryViewModelProtocol

protocol PinEntryViewModelProtocol: AnyObject {
    func viewDidLoad()
}

//MARK: - PinEntryViewModel

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

//MARK: - PinEntryViewModelProtocol Implementation

extension PinEntryViewModel: PinEntryViewModelProtocol {
    
    func viewDidLoad() {
        model.title = "Alexey"
        model.keypadView.handler = { [weak self] action in
            self?.keypadButtonDidTap(action)
        }
        updateRemoveButtonsState()
        view?.configure(with: model)
    }
}

//MARK: - PinEntryViewModelProtocol Private Methods

private extension PinEntryViewModel {
    
    func keypadButtonDidTap(_ action: PinEntryModel.KeypadAction) {
        switch action {
        case .add(let digit):
            guard model.enteredDigits.count < model.requiredPinLength else { return }

            appendToPin(digit)

            if model.enteredDigits.count == model.requiredPinLength {
                let pinCode = model.enteredDigits.map(String.init).joined()
                validatePin(with: pinCode)
            }
        case .removeLast:
            if !model.enteredDigits.isEmpty {
                removeFromPin()
            }
        }
        view?.configure(with: model)
    }
    
    func appendToPin(_ digit: Int) {
        model.enteredDigits.append(digit)
        updateRemoveButtonsState()
    }
    
    func removeFromPin(_ all: Bool = false) {
        if all {
            model.enteredDigits.removeAll()
        } else {
            model.enteredDigits.removeLast()
        }
        updateRemoveButtonsState()
    }
    
    func updateRemoveButtonsState() {
        let isEnabled = !model.enteredDigits.isEmpty
        model.keypadView.buttons = model.keypadView.buttons.map { button in
            guard case .removeLast = button.action else { return button }
            var updatedButton = button
            updatedButton.isEnabled = isEnabled
            return updatedButton
        }
    }
        
    func validatePin(with pinCode: String) {
        
        // Change model state to .updating and turn off keypad.
        model.state = .updating
        model.keypadView.isEnabled = false
        
        dependencies.pinManager.validate(pin: pinCode) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                print("success!")
            case .failure:
                
                // Return model state to .normal and make keypad enabled again.
                self.model.state = .normal
                self.model.keypadView.isEnabled = true
                
                self.removeFromPin(true)
                self.model.title = "Wrong PIN"
            }
            self.view?.configure(with: self.model)
        }
        view?.configure(with: model)
    }
}



