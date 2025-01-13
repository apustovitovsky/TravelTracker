//
//  Created by Алексей on 12.01.2025.
//

import Foundation


protocol PasscodeModuleOutput: AnyObject {
    var completion: Handler<Bool>? { get set }
}

class PasscodePresenter: PasscodePresenterProtocol, PasscodeModuleOutput {
    
    weak var viewController: PasscodeViewControllerProtocol?
    var model: PasscodeModel
    
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
        self.model = model
    }
    
    func didStartInput() {
        model.progressIndicator.state = .normal
    }
    
    func didCompleteInput(_ passcodeString: String) {
        showValidationStart()
        
        passcodeManager.authenticate(with: passcodeString) { [weak self] isSuccessful in
            isSuccessful ? self?.completion?(true) : self?.handleValidationError()
        }
    }
    
    func cancelInput() {
        completion?(false)
    }
    
    func didResetInput() {
        model.state = .normal
    }
    
    func viewDidLoad() {
        currentStep = .enterPasscode
        setupHandlers()
        refreshView()
    }
}

extension PasscodePresenter {
    
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
        
        refreshProgressIndicatorAndView()
    }
}

