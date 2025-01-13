//
//  Created by Алексей on 16.11.2024.
//

import Foundation


// MARK: - PasscodeEntryModuleOutput

protocol PasscodeEntryModuleOutput: AnyObject {
    var completion: Handler<Bool>? { get set }
}

// MARK: - PasscodeEntryPresenter

final class PasscodeEntryPresenter: PasscodeEntryModuleOutput {
    
    var completion: Handler<Bool>?
    weak var viewController: PasscodeViewControllerProtocol?
    
    private var attemptsCount: Int = 22
    private var model: PasscodeModel
    private let passcodeManager: PasscodeManagerProtocol

    init(model: PasscodeModel, passcodeManager: PasscodeManagerProtocol) {
        self.model = model
        self.passcodeManager = passcodeManager
    }
}

// MARK: - PasscodeEntryPresenter: Configurable

extension PasscodeEntryPresenter: PresenterProtocol {
    
    func viewDidLoad() {
        setupHandlers()
        model.title = ".normal"
        updateView()
    }
}

// MARK: - Private Methods

private extension PasscodeEntryPresenter {
    
    func setupHandlers() {
        model.handlers.digitTap = { [weak self] digit in
            self?.handleDigitTap(digit)
        }
        model.handlers.backspaceTap = { [weak self] in
            self?.handleBackspaceTap()
        }
        model.handlers.cancelTap = { [weak self] in
            self?.handleCancelTap()
        }
        model.handlers.resetInput = { [weak self] in
            self?.handleValidationErrorCompletion()
        }
    }
    
    func handleDigitTap(_ digit: Int) {
        guard model.canAddDigit else { return }
        
        model.progressIndicator.state = .normal
        
        model.passcode.append(digit)
        updateProgressIndicator()
        updateView()
        
        if !model.canAddDigit {
            validatePasscode()
        }
    }
    
    func handleBackspaceTap() {
        guard model.canRemoveDigit else { return }
        model.passcode.removeLast()
        updateProgressIndicator()
        updateView()
    }
    
    func handleCancelTap() {
        completion?(false)
    }
    
    func handleValidationErrorCompletion() {
        model.title = ".normal"
        
        model.state = .normal
        
        print(model.state, model.progressIndicator.state)
        model.passcode.removeAll()
        updateProgressIndicator()
        updateView()
    }
    
    func validatePasscode() {
        let passcodeString = model.passcode.map(String.init).joined()
        showValidationProcessing()
        
        passcodeManager.authenticate(with: passcodeString) { [weak self] isSuccessful in
            isSuccessful ? self?.completion?(true) : self?.handleValidationError()
        }
    }
    
    func handleValidationError() {
        attemptsCount > 0 ? showValidationError() : completion?(false)
    }
    
    func showValidationProcessing() {
        model.state = .loading
        print(model.state, model.progressIndicator.state)
        updateView()
    }

    func showValidationError() {
        attemptsCount -= 1
        
        model.state = .failure
        model.progressIndicator.state = .failure
        
        model.title = ".failure"
        print(model.state, model.progressIndicator.state)
        updateProgressIndicator()
        updateView()
    }
    
    func updateProgressIndicator() {
        model.progressIndicator.updateProgress(with: model.passcode.count)
        var str: [String] = []
        model.progressIndicator.circleStates.forEach {
            str.append("\($0)")
        }
        print(str)
    }
    
    func updateView() {
        viewController?.configure(with: model)
    }
}
