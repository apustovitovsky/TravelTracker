//
//  Created by Алексей on 12.01.2025.
//

import Foundation

protocol PasscodePresenterProtocol: PresenterProtocol {
    var completion: ((_: PasscodeValidationResult) -> Void)? { get set }
}

class PasscodePresenterDefault: PasscodePresenterProtocol {
    
    var completion: ((_: PasscodeValidationResult) -> Void)?
    weak var viewController: PasscodeViewControllerProtocol?
    var model: PasscodeModel
    
    init(model: PasscodeModel) {
        self.model = model
    }
    
    func inputDidStart() {
        // Not implemented by default
    }
    
    func inputDidComplete(with passcode: String) {
        // Not implemented by default
    }
    
    func inputDidReset() {
        // Not implemented by default
    }
    
    func cancelInput() {
        // Not implemented by default
    }
 
    func viewDidLoad() {
        configureHandlers()
        updateView()
    }
}

extension PasscodePresenterDefault {
    
    func resetInput() {
        model.passcode.removeAll()
        inputDidReset()
        updateProgressIndicator()
        updateView()
    }
    
    func updateProgressIndicator() {
        model.progressIndicator.updateIndicatorStates(with: model.passcode.count)
        print(model.progressIndicator.indicatorStates.map { "\($0)" })
    }
    
    func updateView() {
        viewController?.configure(with: model)
    }
}

private extension PasscodePresenterDefault {
    
    func configureHandlers() {
        model.handlers.digitTap = { [weak self] in
            self?.handleDigitTap($0)
        }
        model.handlers.backspaceTap = { [weak self] in
            self?.handleBackspaceTap()
        }
        model.handlers.cancelTap = { [weak self] in
            self?.handleCancelTap()
        }
    }
    
    func handleDigitTap(_ digit: Int) {
        guard model.canAddDigit else { return }

        if model.passcode.isEmpty {
            inputDidStart()
        }
        
        model.passcode.append(digit)
        updateProgressIndicator()
        updateView()
        
        if !model.canAddDigit {
            let passcodeString = model.passcode.map(String.init).joined()
            inputDidComplete(with: passcodeString)
        }
    }
    
    func handleBackspaceTap() {
        guard model.canRemoveDigit else { return }
        
        model.passcode.removeLast()
        updateProgressIndicator()
        updateView()
    }
    
    func handleCancelTap() {
        cancelInput()
    }
}

