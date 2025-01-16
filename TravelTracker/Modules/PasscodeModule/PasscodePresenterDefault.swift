//
//  Created by Алексей on 12.01.2025.
//

import Foundation


class PasscodePresenterDefault: PresenterProtocol {

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
        setupHandlers()
        refreshView()
    }
}

extension PasscodePresenterDefault {
    
    func handleResetInput() {
        model.passcode.removeAll()
        inputDidReset()
        updateProgressIndicatorAndRefreshView()
    }
    
    func updateProgressIndicatorAndRefreshView() {
        model.progressIndicator.updateProgress(with: model.passcode.count)
        refreshView()
        print(model.progressIndicator.circleStates.map { "\($0)" })
    }
    
    func refreshView() {
        viewController?.configure(with: model)
    }
}

private extension PasscodePresenterDefault {
    
    func setupHandlers() {
        model.handlers.digitTap = { [weak self] in
            self?.handleDigitTap($0)
        }
        model.handlers.backspaceTap = { [weak self] in
            self?.handleBackspaceTap()
        }
        model.handlers.cancelTap = { [weak self] in
            self?.handleCancelTap()
        }
        model.handlers.resetInput = { [weak self] in
            self?.handleResetInput()
        }
    }
    
    func handleDigitTap(_ digit: Int) {
        guard model.canAddDigit else { return }

        if model.passcode.isEmpty {
            inputDidStart()
        }
        
        model.passcode.append(digit)
        updateProgressIndicatorAndRefreshView()
        
        if !model.canAddDigit {
            let passcodeString = model.passcode.map(String.init).joined()
            inputDidComplete(with: passcodeString)
        }
    }
    
    func handleBackspaceTap() {
        guard model.canRemoveDigit else { return }
        
        model.passcode.removeLast()
        updateProgressIndicatorAndRefreshView()
    }
    
    func handleCancelTap() {
        cancelInput()
    }
}

