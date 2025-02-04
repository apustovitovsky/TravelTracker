//
//  Created by Алексей on 12.01.2025.
//

import Foundation
import RouteComposer

final class PasscodeValidationPresenter: PasscodePresenterDefault {
    
    private let passcodeManager: PasscodeManagerProtocol
    private var currentStep: Steps = .enterPasscode {
        didSet {
            updateTitle(for: currentStep)
        }
    }
    
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
    
    func handlePasscode(_ passcode: String) {
        validatePasscode(passcode)
    }
    
    func validatePasscode(_ passcode: String) {
        passcodeManager.validate(with: passcode) { [weak self] isSuccessful in
            isSuccessful
            ? self?.onValidationSuccess()
            : self?.onValidationFailure()
        }
    }
    
    func onValidationSuccess() {
        completion?(.success)
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

private extension PasscodeValidationPresenter {
    
    enum Constants {
        static let normalToPendingDelay: TimeInterval = 0.4
        static let pendingToFailureDelay: TimeInterval = 0.4
    }
    
    enum Steps: String {
        case enterPasscode = "Enter Passcode"
        case wrongPasscode = "Wrong Passcode"
    }
}

private extension PasscodeValidationPresenter {
    
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
    
    func updateTitle(for step: Steps) {
        model.title = step.rawValue
    }
    
    func performAfter(_ delay: TimeInterval, action: @escaping () -> Void) {
         DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: action)
     }
}

