//
//  Created by Алексей on 08.10.2024.
//

import Foundation

// MARK: - PinSetupFlow

final class PinCodeSetupFlow: Flow {

    private enum FlowStep {
        case checkPin
        case setupPin
    }
    
    var completion: Handler<PinCodeFlowResult>?
    
    private var currentStep: FlowStep = .checkPin
    private var enteredPin: String?
    
    func start() -> Handler<String> {
        self.completion?(.init(prompt: "Enter PIN"))
        
        return { [weak self] pinCode in
            switch self?.currentStep {
            case .checkPin: self?.handlePinCheck(pinCode)
            case .setupPin: self?.handlePinSetup(pinCode)
            default: return
            }
        }
    }
}

// MARK: - PinSetupFlow Private Methods

private extension PinCodeSetupFlow {
    
    func handlePinCheck(_ pinCode: String) {
        PinCodeService.shared.authenticate(with: pinCode) { isAuthenticated in
            guard isAuthenticated else {
                self.completion?(.init(resultType: .wrongPin, prompt: "Wrong PIN"))
                return
            }
            self.currentStep = .setupPin
            self.completion?(.init(prompt: "Setup PIN"))
        }
    }
    
    func handlePinSetup(_ pinCode: String) {
        guard let enteredPin = self.enteredPin else {
            self.enteredPin = pinCode
            self.completion?(.init(prompt: "Repeat PIN"))
            return
        }
        if pinCode == enteredPin {
            PinCodeService.shared.storePin(pin: pinCode)
            self.completion?(.init(resultType: .flowCompleted))
        } else {
            self.completion?(.init(prompt: "PIN missmatch"))
        }
    }
}
