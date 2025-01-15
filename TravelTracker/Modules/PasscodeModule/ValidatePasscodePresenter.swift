//
//  Created by Алексей on 12.01.2025.
//

import Foundation


protocol PasscodeModuleOutput: AnyObject {
    var completion: Handler<Bool>? { get set }
}

final class ValidatePasscodePresenter: PasscodePresenterDefault, PasscodeModuleOutput {
    
    enum State: String {
        case enterPasscode = "Enter Passcode"
        case wrongPasscode = "Wrong Passcode"
    }
    
    var completion: Handler<Bool>?
    private let passcodeManager: PasscodeManagerProtocol
    private var currentStep: State? {
        didSet {
            model.title = currentStep?.rawValue
        }
    }
    
    init(model: PasscodeModel, passcodeManager: PasscodeManagerProtocol) {
        self.passcodeManager = passcodeManager
        super.init(model: model)
    }
    
    override func didStartInput() {
        model.progressIndicator.state = .normal
    }
    
    override func didCompleteInput(with passcode: String) {
        showValidationStart()
        passcodeManager.authenticate(with: passcode) { [weak self] isSuccessful in
            isSuccessful ? self?.completion?(true) : self?.handleValidationError()
        }
    }
    
    override func cancelInput() {
        completion?(false)
    }
    
    override func didResetInput() {
        model.state = .normal
    }
    
    override func viewDidLoad() {
        currentStep = .enterPasscode
        super.viewDidLoad()
    }
}

private extension ValidatePasscodePresenter {
    
    func showValidationStart() {
        model.state = .loading
        refreshView()
    }
    
    func handleValidationError() {
        model.remainingAttempts > 0 ? showValidationError() : completion?(false)
    }
    
    func showValidationError() {
        model.remainingAttempts -= 1
        
        currentStep = .wrongPasscode
        model.state = .failure
        model.progressIndicator.state = .failure
        
        updateProgressIndicatorAndRefreshView()
    }
}

