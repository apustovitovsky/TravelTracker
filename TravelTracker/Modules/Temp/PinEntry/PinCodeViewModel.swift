//
//  Created by Алексей on 23.09.2024.
//

import Foundation

// MARK: - PinModuleOutput

protocol PinCodeModuleOutput: AnyObject {
    var completion: Handler<Bool>? { get set }
}

// MARK: - PinViewModelProtocol

protocol PinCodeViewModelProtocol: AnyObject {
    func viewDidLoad()
}

// MARK: - PinViewModel

final class PinCodeViewModel<F: PinCodeFlow>: PinCodeModuleOutput where F.Context == PinCodeFlowResult {
    
    var completion: Handler<Bool>?
    weak var view: PinCodeViewControllerProtocol?
    
    private var model: PinCodeModel
    private var flow: F
    
    init(model: PinCodeModel, flow: F) {
        self.model = model
        self.flow = flow
    }
}

// MARK: - PinViewModelProtocol Implementation

extension PinCodeViewModel: PinCodeViewModelProtocol {
    
    func viewDidLoad() {
        setupHandlers()
        flow.start()
        updateKeypad()
        view?.configure(with: model)
    }
}

//MARK: - PinViewModel Private Methods

private extension PinCodeViewModel {
    
    // MARK: - pinCode Property
    
    private var pinCode: [Int] {
        set {
            model.indicatorView.previousPinCode = model.indicatorView.pinCode
            model.indicatorView.pinCode = newValue
            updateKeypad()
        }
        get {
            return model.indicatorView.pinCode
        }
    }
    
    // MARK: - setupHandlers
    
    func setupHandlers() {
        model.keypadView.handler = { [weak self] action in
            self?.handleKeypadAction(action)
        }
        flow.completion = { [weak self] result in
            self?.handleFlowResult(result)
        }
        model.indicatorView.onAnimationComplete = { [weak self] _ in
            self?.handleAnimationResult()
        }
    }
    
    // MARK: - handleCoordinatorResult
    
    func handleAnimationResult() {
        model.indicatorView.state = .none
        model.keypadView.state = .normal
    }

    // MARK: - handleCoordinatorResult
    
    func handleFlowResult(_ result: F.Context) {

        switch result.actionType {
        case .clearPin:
            model.indicatorView.state = .clearPin
//            model.indicatorView.onAnimationComplete = { [weak self] _ in
//                guard let self, self.model.indicatorView.state != .normal else { return }
//                self.pinCode.removeAll()
//                self.model.indicatorView.state = .normal
//                self.view?.configure(with: self.model)
//            }
        case .wrongPin:
            model.indicatorView.state = .wrongPin
            model.keypadView.state = .disabled
//            model.indicatorView.onAnimationComplete = { [weak self] _ in
//                guard let self, self.model.indicatorView.state != .normal else { return }
//                self.pinCode.removeAll()
//                self.model.promptLabel.text = result.prompt
//                self.model.indicatorView.state = .normal
//                self.model.keypadView.state = .normal
//                self.view?.configure(with: self.model)
//            }
        case .completeFlow:
            completion?(true)
            return
        }
        view?.configure(with: model)
    }

    // MARK: - updateKeypad
    
    func updateKeypad() {
        let maxPinLengthReached = pinCode.count == model.indicatorView.pinCodeLength
        model.keypadView.state = maxPinLengthReached ? .disabled : .normal
        model.keypadView.buttons = model.keypadView.buttons.map { button in
            guard case .removeLast = button.action else { return button }
            var updatedButton = button
            updatedButton.state = pinCode.isEmpty ? .disabled : .normal
            return updatedButton
        }
    }
    
    // MARK: - handleKeypadAction
    
    func handleKeypadAction(_ action: PinCodeModel.KeypadView.ActionType) {
        let pinCodeLength = model.indicatorView.pinCodeLength
        
        switch action {
        case .append(let digit):
            guard pinCode.count < pinCodeLength else { return }
            pinCode.append(digit)
        case .removeLast:
            guard !pinCode.isEmpty else { return }
            pinCode.removeLast()
        case .cancelFlow:
            completion?(false)
            return
        }
        model.indicatorView.state = .setupPin
        view?.configure(with: model)
        
        guard pinCode.count == pinCodeLength else { return }
        let pinCodeString = pinCode.map(String.init).joined()
        flow.handler?(pinCodeString)
    }
}



