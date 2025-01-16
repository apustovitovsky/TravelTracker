//
//  Created by Алексей on 12.01.2025.
//

import Foundation


protocol PasscodeModuleOutput: AnyObject {
    var completion: Handler<String>? { get set }
}

final class ValidatePasscodePresenter: PasscodePresenterDefault, PasscodeModuleOutput {
    
    enum Prompts {
        static let enterPasscodePrompt = "Enter Passcode"
        static let wrongPasscodePrompt = "Wrong Passcode"
    }
    
    var completion: Handler<String>?
    private let passcodeManager: PasscodeManagerProtocol
    
    init(model: PasscodeModel, passcodeManager: PasscodeManagerProtocol) {
        self.passcodeManager = passcodeManager
        super.init(model: model)
    }
    
    override func inputDidStart() {
        model.progressIndicator.state = .normal
    }
    
    override func inputDidComplete(with passcode: String) {
//        model.handlers.processInput = { [weak self] in
//            self?.handleProcessPasscode(passcode)
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.handleProcessPasscode(passcode)
        }
        
        model.state = .loading
        refreshView()
    }
    
    override func inputDidReset() {
        model.state = .normal
    }
    
    override func cancelInput() {
        completion?("false")
    }
    
    override func viewDidLoad() {
        model.title = Prompts.enterPasscodePrompt
        super.viewDidLoad()
    }
}

private extension ValidatePasscodePresenter {
    
    func handleProcessPasscode(_ passcode: String) {
        passcodeManager.authenticate(with: passcode) { [weak self] isSuccessful in
            isSuccessful
                ? self?.handleValidationSuccess()
                : self?.handleValidationFailure()
        }
    }
    
    func handleValidationSuccess() {
        completion?("true")
    }
    
    func handleValidationFailure() {
        guard model.remainingAttempts > 0 else {
            completion?("false")
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.handleResetInput()
        }
        
        model.title = Prompts.wrongPasscodePrompt
        model.state = .failure
        model.progressIndicator.state = .failure
        model.remainingAttempts -= 1
        updateProgressIndicatorAndRefreshView()
    }
}

