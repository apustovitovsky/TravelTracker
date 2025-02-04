//
//  Created by Алексей on 12.01.2025.
//

import Foundation
import RouteComposer

final class PasscodeSetupPresenter: PasscodePresenterDefault {
    
    private let passcodeManager: PasscodeManagerProtocol
    private var currentStep: Steps = .enterPasscode {
        didSet {
            updateTitle(for: currentStep)
        }
    }
    private var storedPasscode: String?
    
    init(model: PasscodeModel, passcodeManager: PasscodeManagerProtocol) {
        self.passcodeManager = passcodeManager
        super.init(model: model)
    }
    
    override func inputDidComplete(with passcode: String) {
        setPendingState()
        
        performAfter(Constants.normalToPendingDelay) { [weak self] in
            self?.handlePasscode(passcode)
        }
    }
    
    override func cancelInput() {
        cancelPasscodeValidation()
    }
    
    override func inputDidStart() {
        setNormalState()
    }
    
    override func inputDidReset() {
        setResetState()
    }
    
    override func viewDidLoad() {
        updateTitle(for: currentStep)
        super.viewDidLoad()
    }
}

private extension PasscodeSetupPresenter {
    
    enum Constants {
        static let normalToPendingDelay: TimeInterval = 0.4
        static let pendingToFailureDelay: TimeInterval = 0.4
    }
    
    enum Steps: String {
        case enterPasscode = "Enter Passcode"
        case wrongPasscode = "Wrong Passcode"
        case createPasscode = "Create Passcode"
        case confirmPasscode = "Repeat Passcode"
        case passcodeMismatch = "Passcode Mismatch"
    }
}

private extension PasscodeSetupPresenter {
    
    func handlePasscode(_ passcode: String) {
        switch currentStep {
        case .enterPasscode, .wrongPasscode:
            validatePasscode(passcode)
        case .createPasscode:
            storePasscode(passcode)
        case .confirmPasscode, .passcodeMismatch:
            confirmPasscode(passcode)
        }
    }
    
    func validatePasscode(_ passcode: String) {
        passcodeManager.validate(with: passcode) { [weak self] isSuccessful in
            isSuccessful
            ? self?.onValidationSuccess()
            : self?.onValidationFailure()
        }
    }
    
    func onValidationSuccess() {
        currentStep = .createPasscode
        resetInput()
    }
    
    func onValidationFailure() {
        model.remainingAttempts > 0 ? resumeToPasscodeValidation() : cancelPasscodeValidation()
        model.remainingAttempts -= 1
    }
    
    func resumeToPasscodeValidation() {
        currentStep = .wrongPasscode
        updateProgressIndicator()
        setFailureState()
        
        performAfter(Constants.pendingToFailureDelay) { [weak self] in
            self?.resetInput()
        }
    }
    
    func cancelPasscodeValidation() {
        completion?(.failure(RoutingError.generic(.init("Passcode validation failed"))))
    }
    
    func storePasscode(_ passcode: String) {
        currentStep = .confirmPasscode
        storedPasscode = passcode
        resetInput()
    }
    
    func confirmPasscode(_ passcode: String) {
        storedPasscode == passcode ? onConfirmationSuccess() : onConfirmationFailure()
    }
    
    func onConfirmationSuccess() {
        completion?(.success)
    }
    
    func onConfirmationFailure() {
        currentStep = .passcodeMismatch
        updateProgressIndicator()
        setMismatchState()
        
        performAfter(Constants.pendingToFailureDelay) { [weak self] in
            self?.resetInput()
        }
    }
    
    func setNormalState() {
        model.progressIndicator.state = .normal
        updateView()
    }
    
    func setResetState() {
        model.state = .normal
        updateView()
    }
    
    func setPendingState() {
        model.state = .pending
        updateView()
    }
    
    func setFailureState() {
        model.state = .failure
        model.progressIndicator.state = .failure
        updateView()
    }
    
    func setMismatchState() {
        model.state = .failure
        updateView()
    }
    
    func updateTitle(for step: Steps) {
        model.title = step.rawValue
    }
    
    func performAfter(_ delay: TimeInterval, action: @escaping () -> Void) {
         DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: action)
     }
}

