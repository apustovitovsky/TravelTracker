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

final class PinCodeViewModel<F: Flow>: PinCodeModuleOutput, FlowHolder where F.Context == PinCodeFlowResult {
    
    var completion: Handler<Bool>?
    var flow: F
    weak var view: PinCodeViewControllerProtocol?
    
    private var model: PinCodeModel
    private var enterPin: Handler<String>?
    
    init(model: PinCodeModel, flow: F) {
        self.model = model
        self.flow = flow
    }
}

// MARK: - PinViewModelProtocol Implementation

extension PinCodeViewModel: PinCodeViewModelProtocol {
    
    func viewDidLoad() {
        setupHandlers()
        enterPin = flow.start()
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
    }
    
    // MARK: - handleCoordinatorResult
    
    func handleFlowResult(_ result: F.Context?) {
        if let prompt = result?.prompt {
            model.promptLabel = prompt
        }
        switch result?.resultType {
        case .flowCompleted:
            completion?(true)
            return
        case .wrongPin:
            model.indicatorView.state = .wrongPin
        default:
            break
        }
        pinCode.removeAll()
        view?.configure(with: model)
    }

    // MARK: - updateKeypad
    
    func updateKeypad() {
        model.keypadView.isEnabled = model.indicatorView.pinCode.count != model.indicatorView.pinCodeLength
        model.keypadView.buttons = model.keypadView.buttons.map { button in
            guard case .removeLast = button.action else { return button }
            var updatedButton = button
            updatedButton.isEnabled = !pinCode.isEmpty
            return updatedButton
        }
    }
    
    // MARK: - handleKeypadAction
    
    func handleKeypadAction(_ action: PinCodeModel.KeypadView.Action) {
        model.indicatorView.state = .normal

        switch action {
        case .append(let digit):
            guard pinCode.count < model.indicatorView.pinCodeLength else { return }
            pinCode.append(digit)
            if pinCode.count == model.indicatorView.pinCodeLength {
                handlePinCode()
            }
        case .removeLast:
            if !pinCode.isEmpty {
                pinCode.removeLast()
            }
        case .cancelFlow:
            completion?(false)
        }
        view?.configure(with: model)
    }
    
    // MARK: - handlePinCode
    
    func handlePinCode() {
        let pinCodeString = model.indicatorView.pinCode.map(String.init).joined()
        model.indicatorView.state = .processingPin
        enterPin?(pinCodeString)
    }
}



