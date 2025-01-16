//
//  Created by Алексей on 12.01.2025.
//

import Foundation


protocol PasscodeSetupModuleOutput: AnyObject {
    var completion: ((String) -> Void)? { get set }
}

final class CreatePasscodePresenter: PasscodePresenterDefault, PasscodeSetupModuleOutput {
    
    enum Steps {
        case enterPasscode
        case setupPasscode(storedPasscode: String?)
    }

    enum Prompts {
        static let enterPasscodePrompt = "Enter Passcode"
        static let wrongPasscodePrompt = "Wrong passcode"
        static let createPasscodePrompt = "Create Passcode"
        static let repeatPasscodePrompt = "Repeat Passcode"
        static let passcodeMismatchPrompt = "Passcode Mismatch"
    }
    
    var completion: ((String) -> Void)?
    private let passcodeManager: PasscodeManagerProtocol
    private var currentStep: Steps = .setupPasscode(storedPasscode: nil)
    
    init(model: PasscodeModel, passcodeManager: PasscodeManagerProtocol) {
        self.passcodeManager = passcodeManager
        super.init(model: model)
    }
    
    override func inputDidStart() {
        model.progressIndicator.state = .normal
    }
    
    override func inputDidComplete(with passcode: String) {
        showValidationStart()
        
        switch currentStep {
        case .enterPasscode:
            passcodeManager.authenticate(with: passcode) { [weak self] isSuccessful in
                isSuccessful ? self?.handleSetupPasscode() : self?.handleValidationError()
            }
            
        case .setupPasscode(let storedPasscode):
            guard let storedPasscode else {
                handleConfirmPasscode(using: passcode)
                return
            }
            if storedPasscode == passcode {
                completion?("Passcode succefully created")
            } else {
                handlePasscodeMismatch()
            }
        }
    }
    
    override func cancelInput() {
        completion?("Input has been canceled")
    }
    
    override func inputDidReset() {
        model.state = .normal
    }
    
    override func viewDidLoad() {
        model.title = Prompts.enterPasscodePrompt
        super.viewDidLoad()
    }
}

private extension CreatePasscodePresenter {
    
    func showValidationStart() {
        model.state = .loading
        refreshView()
    }
    
    func handleSetupPasscode() {
        model.title = Prompts.createPasscodePrompt
        currentStep = .setupPasscode(storedPasscode: nil)
        handleResetInput()
    }
    
    func handleConfirmPasscode(using passcode: String) {
        model.title = Prompts.repeatPasscodePrompt
        currentStep = .setupPasscode(storedPasscode: passcode)
        handleResetInput()
    }
    
    func handlePasscodeMismatch() {
        model.title = Prompts.passcodeMismatchPrompt
        model.state = .failure
        refreshView()
    }
    
    func handleValidationError() {
        model.remainingAttempts > 0 ? showValidationError() : completion?("You have no attempts")
    }
    
    func showValidationError() {
        model.remainingAttempts -= 1
        
        model.title = Prompts.wrongPasscodePrompt
        model.state = .failure
        model.progressIndicator.state = .failure
        
        updateProgressIndicatorAndRefreshView()
    }
}

