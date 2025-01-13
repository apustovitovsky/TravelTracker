////
////  Created by Алексей on 12.01.2025.
////
//
//import Foundation
//
//
//protocol PasscodeSetupModuleOutput: AnyObject {
//    var completion: Action? { get set }
//}
//
//class PasscodeSetupPresenter: PasscodePresenter, PasscodeSetupModuleOutput {
//    
//    enum Step: String {
//        case enterPasscode
//        case wrongPasscode
//        case createPasscode
//        case confirmPasscode
//        case passcodeMismatch
//    }
//    
//    var completion: Action?
//    private let passcodeManager: PasscodeManagerProtocol
//    var currentStep: Step = .enterPasscode
//    
//    init(model: PasscodeModel, passcodeManager: PasscodeManagerProtocol) {
//        self.passcodeManager = passcodeManager
//        super.init(model: model)
//        self.model.title = self.currentStep
//    }
//    
//    override func setupHandlers() {
//        super.setupHandlers()
//        
//        model.handlers.validationError = { [weak self] in
//            self?.handleEntryReset()
//        }
//        model.handlers.cancelTap = { [weak self] in
//            self?.handleCancelTap()
//        }
//    }
//    
//    override func handleDigitTap(_ digit: Int) {
//        super.handleDigitTap(digit)
//        
//        guard model.isPasscodeEntered else { return }
//        if model.isPasscodeEntered {
//            processPasscode()
//        }
//    }
//    
//    func processPasscode() {
//        let passcodeString = model.passcode.map(String.init).joined()
//        showBeginProcessing()
//        
//        switch step {
//        case .validation:
//            processValidation(with: passcodeString)
//        case .creation:
//            processCreation(with: passcodeString)
//        case .confirmation(_):
//            processConfirmation(with: passcodeString)
//        }
//    }
//    
//    override func startFlow() {
//        super.startFlow()
//    }
//    
//    func processValidation(with passcodeString: String) {
//        passcodeManager.authenticate(with: passcodeString) { [weak self] isSuccessful in
//            isSuccessful ? self?.handleValidationPassed() : self?.handleValidationError()
//        }
//    }
//    
//    // validation passed, goes next step
//    func handleValidationPassed() {
//        step = .creation
//        handleEntryReset()
//    }
//    
//    func processCreation(with passcodeString: String) {
//        
//    }
//    
//    func processConfirmation(with passcodeString: String) {
//        
//    }
//    
//    func handleValidationError() {
//        model.remainingAttempts > 0 ? showValidationError() : completion?()
//    }
//    
//    func showBeginProcessing() {
//        model.state = .loading
//        model.title = ".loading"
//        updateView()
//    }
//    
//    func showValidationError() {
//        model.remainingAttempts -= 1
//        
//        model.state = .failure
//        model.progressIndicator.state = .failure
//        
//        model.title = ".failure"
//        print(model.state, model.progressIndicator.state)
//        updateProgressIndicator()
//        updateView()
//    }
//    
//    func handleEntryReset() {
//        model.title = ".normal"
//        
//        model.state = .normal
//    
//        model.passcode.removeAll()
//        updateProgressIndicator()
//        updateView()
//    }
//    
//    func handleCancelTap() {
//        completion?()
//    }
//}
