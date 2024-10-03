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
        if !dependencies.pinManager.isPinStored() {
            model.title = "Create PIN"
            model.state = .setupPin(.none)
        } else {
            model.title = "Enter PIN"
        }

        model.keypadView.handler = { [weak self] action in
            self?.handleKeypadAction(action)
        }
        updateKeypad()
        view?.configure(with: model)
    }
}

//MARK: - PinEntryViewModelProtocol Private Methods

private extension PinEntryViewModel {
    
    // MARK: - pinCode
    
    // Property to get and set entered digits. Updates the keypad whenever changes occur.
    private var pinCode: [Int] {
        set {
            model.enteredDigits = newValue
            updateKeypad()
        }
        get {
            return model.enteredDigits
        }
    }
    
    // MARK: - handleKeypadAction
    
    // Respond to keypad button actions (add digit or remove last)
    func handleKeypadAction(_ action: PinEntryModel.KeypadAction) {
        switch action {
        case .add(let digit):
            // Ensure that the entered PIN does not exceed the required length
            guard pinCode.count < model.requiredPinLength else { return }
            
            // Add the new digit to the entered PIN
            pinCode.append(digit)
            
            // If the required number of digits is entered, process the PIN code
            if pinCode.count == model.requiredPinLength {
                handlePinCode()
            }
        case .removeLast:
            if !pinCode.isEmpty {
                // Remove the last digit from the entered PIN if it's not empty
                pinCode.removeLast()
            }
        }
        
        // Update the view after each action
        view?.configure(with: model)
    }
    
    // MARK: - updateKeypad
    
    func updateKeypad() {
        model.keypadView.buttons = model.keypadView.buttons.map { button in
            guard case .removeLast = button.action else { return button }
            var updatedButton = button
            updatedButton.isEnabled = !pinCode.isEmpty
            return updatedButton
        }
    }
        
    // MARK: - handlePinCode
    
    func handlePinCode() {
        
        // Map collected PIN digits into a string and clear it
        let enteredPinCode = pinCode.map(String.init).joined()
        pinCode.removeAll()

        // Handle PIN code string depending on model state
        switch model.state {
        case .enterPin:
            handleEnterPinState(enteredPinCode)
        case .setupPin(let storedPinCode):
            handleSetupPinState(enteredPinCode, storedPin: storedPinCode)
        case .wrongPin:
            handleWrongPinState(enteredPinCode)
        }

        view?.configure(with: model)
    }
    
    // MARK: - handleEnterPinState
    
    func handleEnterPinState(_ pinCode: String) {
        dependencies.pinManager.checkPin(pin: pinCode) { [weak self] result in
            switch result {
            case .success:
                self?.model.title = "PIN is ok"
                self?.model.state = .setupPin(.none)
            case .failure:
                self?.model.title = "PIN is invalid"
                self?.model.state = .wrongPin
            }
        }
    }
    
    // MARK: - handleSetupPinState
    
    func handleSetupPinState(_ pinCode: String, storedPin: String?) {
        if let storedPin {
            if pinCode == storedPin {
                model.title = "PIN created"
                model.keypadView.isEnabled = false
                dependencies.pinManager.storePin(pin: pinCode)
            } else {
                model.title = "PIN missmatch"
            }
        } else {
            model.title = "Repeat PIN"
            model.state = .setupPin(pinCode)
        }
    }
    
    //MARK: - handleWrongPinState
    
    func handleWrongPinState(_ pinCode: String) {
        dependencies.pinManager.checkPin(pin: pinCode) { [weak self] result in
            switch result {
            case .success:
                self?.model.title = "PIN is valid"
                self?.model.state = .setupPin(.none)
            case .failure:
                self?.model.title = "PIN entry suspended"
                self?.model.keypadView.isEnabled = false
            }
        }
    }
}



