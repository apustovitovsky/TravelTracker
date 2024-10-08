//
//  Created by Алексей on 23.09.2024.
//

import UIKit

//MARK: - PinEntryViewModelProtocol

protocol PinEntryViewModelProtocol: AnyObject {
    func viewDidLoad()
    var completion: Action? { get set }
}

//MARK: - PinEntryViewModel

final class PinEntryViewModel<PinFlow: PinFlowProtocol> where PinFlow.Result == PinEntryModel.Result {
    
    var completion: Action?
    
    weak var view: PinEntryViewControllerProtocol?
    private var model: PinEntryModel
    
    private let coordinator: PinFlow
    private var pinStep: Handler<String>?
    
    init(model: PinEntryModel, pinFlow: PinFlow) {
        self.model = model
        self.coordinator = pinFlow
    }
}

//MARK: - PinEntryViewModelProtocol Implementation

extension PinEntryViewModel: PinEntryViewModelProtocol {
    
    func viewDidLoad() {
        
        // Setup keypad Handler
        model.keypadView.handler = { [weak self] action in
            self?.handleKeypad(action)
        }
        
        // Setup Coordinator Handler
        coordinator.handler = { [weak self] result in
            self?.handleCoordinator(result)
        }
        
        pinStep = coordinator.start()
        updateKeypad()
        view?.configure(with: model)
    }
}

//MARK: - PinEntryViewModelProtocol Private Methods

private extension PinEntryViewModel {
    
    // MARK: - pinCode Property

    private var pinCode: [Int] {
        set {
            model.enteredDigits = newValue
            updateKeypad()
        }
        get {
            return model.enteredDigits
        }
    }
    
    // MARK: - handleCoordinator
    
    func handleCoordinator(_ result: PinFlow.Result) {
        if let title = result.title {
            self.model.title = title
        }
    }
    
    // MARK: - handleKeypad
    
    func handleKeypad(_ action: PinEntryModel.KeypadAction) {
        switch action {
        case .add(let digit):
            guard pinCode.count < model.requiredPinLength else { return }
            pinCode.append(digit)
            if pinCode.count == model.requiredPinLength {
                handlePinCode()
            }
        case .removeLast:
            if !pinCode.isEmpty {
                pinCode.removeLast()
            }
        }
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
        let enteredPinCode = pinCode.map(String.init).joined()
        pinCode.removeAll()
        pinStep?(enteredPinCode)
    }
}



