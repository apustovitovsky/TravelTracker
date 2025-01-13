//
//  Created by Алексей on 12.01.2025.
//

import Foundation


protocol PasscodePresenterProtocol: PresenterProtocol {
    
    var viewController: PasscodeViewControllerProtocol? { get set }
    var model: PasscodeModel { get set }
    
    func didStartInput()
    func didCompleteInput(_ passcodeString: String)
    func didResetInput()
    func cancelInput()
    func refreshProgressIndicatorAndView()
    func refreshView()
}

extension PasscodePresenterProtocol {
    
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
    
    func refreshProgressIndicatorAndView() {
        model.progressIndicator.updateProgress(with: model.passcode.count)
        refreshView()
        print(model.progressIndicator.circleStates.map { "\($0)" })
    }
    
    func refreshView() {
        viewController?.configure(with: model)
    }
}

private extension PasscodePresenterProtocol {
    
    func handleDigitTap(_ digit: Int) {
        guard model.canAddDigit else { return }

        if model.passcode.isEmpty {
            didStartInput()
        }
        model.passcode.append(digit)
        refreshProgressIndicatorAndView()
        
        if !model.canAddDigit {
            let passcodeString = model.passcode.map(String.init).joined()
            didCompleteInput(passcodeString)
        }
    }
    
    func handleResetInput() {
        model.passcode.removeAll()
        didResetInput()
        refreshProgressIndicatorAndView()
    }
    
    func handleBackspaceTap() {
        guard model.canRemoveDigit else { return }
        
        model.passcode.removeLast()
        refreshProgressIndicatorAndView()
    }
    
    func handleCancelTap() {
        cancelInput()
    }
}


//class PasscodePresenter: PresenterProtocol {
//    
//    weak var viewController: PasscodeViewControllerProtocol?
//    var model: PasscodeModel
//    
//    init(model: PasscodeModel) {
//        self.model = model
//    }
//    
//    func onInputCompleted(_ passcodeString: String) {}
//    
//    func onInputReset() {
//    }
//    
//    func onInputStarted() {
//    }
//    
//    func cancelFlow() {
//    }
//    
//    func viewDidLoad() {
//        setupHandlers()
//        configureView()
//    }
//}
//
//extension PasscodePresenter {
//    
//    func updateProgressIndicator() {
//        model.progressIndicator.updateProgress(with: model.passcode.count)
//        print(model.progressIndicator.circleStates.map { "\($0)" })
//    }
//    
//    func configureView() {
//        viewController?.configure(with: model)
//    }
//}
//
//private extension PasscodePresenter {
//    
//    func setupHandlers() {
//        model.handlers.digitTap = { [weak self] in
//            self?.handleDigitTap($0)
//        }
//        model.handlers.backspaceTap = { [weak self] in
//            self?.handleBackspaceTap()
//        }
//        model.handlers.cancelTap = { [weak self] in
//            self?.handleCancelTap()
//        }
//        model.handlers.resetInput = { [weak self] in
//            self?.handleResetInput()
//        }
//    }
//    
//    func handleResetInput() {
//        model.passcode.removeAll()
//        onInputReset()
//        
//        updateProgressIndicator()
//        configureView()
//    }
//    
//    func handleDigitTap(_ digit: Int) {
//        guard model.canAddDigit else { return }
//
//        if model.passcode.isEmpty {
//            onInputStarted()
//        }
//        model.passcode.append(digit)
//
//        updateProgressIndicator()
//        configureView()
//        
//        if !model.canAddDigit {
//            let passcodeString = model.passcode.map(String.init).joined()
//            onInputCompleted(passcodeString)
//        }
//    }
//    
//    func handleBackspaceTap() {
//        guard model.canRemoveDigit else { return }
//        
//        model.passcode.removeLast()
//        
//        updateProgressIndicator()
//        configureView()
//    }
//    
//    func handleCancelTap() {
//        cancelFlow()
//    }
//}
